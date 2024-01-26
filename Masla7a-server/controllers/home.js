const Validator = require('../validators/complaint-validator');
const mongoose = require("mongoose");
const _ = require("lodash");
const Complaint = require('../models/complaint');
const User = require("../models/user-model");
const Service = require('../models/service-model');
const Category = require('../models/category-model');
const Order = require('../models/order-model');
// const transporter = require('../utils/emails-utils');


exports.homePage = async (req, res) => {
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const userID = mongoose.Types.ObjectId(req.params.id);
  const user = await User.findById(userID);
  if (!user)
    return res.status(400).json({ message: "There is no User with such ID " });


  const userInfo = await User.findById(userID)
    .populate("users")
    .select("name userName profilePic location role");

  res.status(200).json({ user: userInfo });
};

exports.getAllServiceProviders = async (req, res) => {

  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");
  const userID = mongoose.Types.ObjectId(req.params.id);

  const serviceProviders = await User
    .find({ role: 'serviceProvider' })
    .populate('serviceId', '-gallery -ordersList -serviceProviderId -categoryId')
    .select('name gender age profilePic userName availability ')

  if (serviceProviders.length === 0)
    return res.status(200).json({ message: 'NO SERVICE PROVIDERS YET' })

  const user = await User.findById(userID);

  serviceProviders.forEach((serviceProvider) => {
    if (user.favouritesList.includes(serviceProvider.serviceId._id)) {
      //console.log('YES')
      serviceProvider.favourite = true
      //console.log(serviceProvider.favourite)
    }
    else {
      //console.log('NO')
      serviceProvider.favourite = false;
      // console.log(serviceProvider.favourite)
    }
  })

  console.log(serviceProviders[0].favourite)

  const obj = [{ name: 'reem', email: 'olaa' }, { name: 'arwa', email: 'plaaa' }]
  obj[0].favourite = false
  console.log(obj)
  return res.status(200).json({ serviceProviders })
}

exports.changeAvailability = async (req, res) => {
  try {

    const user = await User.findById(req.user._id);

    if (!user)
      return res.status(400).json({
        message: 'User Not Found'
      });

    req.body.availability = !req.body.availability ?
      'offline' : req.body.availability;

    user.availability = req.body.availability;

    if (user.role === 'serviceProvider') {
      const orders = await Order.find({ serviceProviderId: user._id });
      orders.forEach(order => {
        if (new Date() >= order.startsAt && new Date() <= order.endsAt) {
          user.availability = 'busy';
        }
      });
    }

    await user.save();

    res.status(202).json({
      status: 'Success',
      user: user
    });

  } catch (err) {
    res.status(500).json({
      messgae: err.message
    });
  }
};
//#region Posting A Complaint
exports.postComplaint = async (req, res) => {

  try {

    const { error } = await Validator.validateComplaint(req.body);

    if (error)
      return res.status(400).json(error.details[0].message);

    const senderUser = await User.findById(req.user._id);


    if (!senderUser)
      return res.status(400).json({
        status: 'Failed',
        message: 'The User in The Token Was Not Found.'
      });


    const serviceProvider = await User
      .findOne({
        userName: req.body.userName
      });


    if (!serviceProvider ||
      serviceProvider.role !== 'serviceProvider')
      return res.status(400).json('There is no serviceprovider with such username');


    const order = await Order.findOne({
      serviceProviderId: serviceProvider._id,
      customerId: senderUser._id,
      status: { $in: ['completed', 'canceled'] }
    });


    


    const previousComplaint = await Complaint
      .findOne({
        serviceProvider: serviceProvider._id,
        user: senderUser._id
      });

    if (previousComplaint)
      return res.status(400).json('You Have Already submited A compliant');

    const complaint = new Complaint({
      serviceProvider: serviceProvider._id,
      user: senderUser._id,
      complaintType: req.body.complaintType,
      description: req.body.description
    });

    await complaint.save();


    let orders = await Order.find({
      serviceProviderId: serviceProvider._id,
      status: { $in: ['completed', 'canceled'] }
    });


    let complaints = await Complaint
      .aggregate([
        {
          $match: {
            serviceProvider: mongoose.Types.ObjectId(serviceProvider._id)
          }
        },
        {
          $group: {
            _id: '$complaintType',
            count: {
              $sum: 1
            }
          }
        },
        {
          $sort: {
            count: -1
          }
        }
      ]);

    let totalComplaints = 0;


    complaints.forEach(complaint => {
      totalComplaints += complaint.count;
    })


    if (complaints.length > 0) {
      if (orders.length >= 15) {
        if (complaints.length >= (orders.length / 2)) {

          const user = await User.findByIdAndRemove(serviceProvider._id);

          const service = await Service.findOneAndRemove({ serviceProviderId: user._id })

          const category = await Category.findById(service.categoryId).populate();

          const index = category.servicesList.indexOf(service._id);
          if (index > -1) {
            category.servicesList.splice(index, 1);
          }

          orders = await Order.find({ serviceProviderId: user._id });

          if (orders.length > 0) {
            for (let i = 0; i < orders.length; i++) {
              await Order.findByIdAndRemove(orders[i]._id);
            }
          }

          await category.save();


          complaints = await Complaint.find({
            serviceProvider: user._id
          });


          if (complaints.length > 0) {
            for (let i = 0; i < complaints.length; i++) {
              await Complaint.findByIdAndRemove(complaints[i]._id);
            }
          }

          // await transporter.sendMail({
          //   to: user.email,
          //   from: 'masla7ateam@gmail.com',
          //   subject: 'Complaints',
          //   html: `<h1>Alert!</h1>
          //   <h3>Dear ${serviceProvider.name}</h3>
          //   <p>
          //   We are sorry to tell you that your account has been deleted
          //   </p>
          //   `
          // });

          return res.status(200).json({
            message: 'Complaint Has Been Submited Successfully',
          });
        }
      }
    }


    // await transporter.sendMail({
    //   to: serviceProvider.email,
    //   from: 'masla7ateam@gmail.com',
    //   subject: 'Complaints',
    //   html: `<h1>Alert!</h1>
    //   <h3>Dear ${serviceProvider.name}</h3>
    //   <p>We are sorry to tell you that you have ${totalComplaints} complaints about the orders you placed, 
    //   please try to resolve these complaints, otherwise, your account will be deleted when 
    //   you reach ${(orders.length <= 15) ? 15 : Math.ceil(orders.length / 2)} complaints.
    //   </p>
    //   <p>
    //   <strong>Note:</strong> The most frequent complaint is "${complaints[0]._id}"
    //   </p>
    //   `
    // });


    return res.status(200).json({
      message: 'Complaint Has Been Submited Successfully',
    });

  } catch (err) {
    res.status(500).json({
      message: err.message
    });
  }
}
//#endregion
