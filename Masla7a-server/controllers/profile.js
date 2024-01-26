const User = require("../models/user-model");
const Service = require("../models/service-model");
const Review = require("../models/review");
const Order = require("../models/order-model");
const Category = require("../models/category-model");
const validator = require("../validators/user-validator");
const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const cloud = require("../images/images-controller/cloudinary");
const fs = require("fs");

//#region Getting profile information
exports.getUserInfo = async (req, res, next) => {
  if (req.params.id.length != 24) return res.status(404).json("Invalid ID");

  const userID = mongoose.Types.ObjectId(req.params.id);
  const user = await User.findById(userID)
    .select("name userName profilePic availability gender age phone_number address");

  if (!user)
    return res.status(400).json({ message: "There is no User with such ID " });

  const service = await Service.findOne({ serviceProviderId: userID })
    .populate("services")
    .select("serviceName servicePrice description gallery averageRating numberOfRatings");
  const reviews = await Review.find({ serviceID: service._id })
    .populate("user", "name profilePic  -_id")
    .select("title content rating _id ");

  const schedule = await Order
    .find({ serviceProviderId: userID, status: { $nin: ['completed', 'canceled'] } })


  //Changing Avaibility Of The Service Provider Into Busy If He/She 
  if (schedule) {
    let currentDate = new Date()
    currentDate.setHours(currentDate.getHours() + 2)
    schedule.map(appointment => {
      if (currentDate >= appointment.startsAt && currentDate <= appointment.endsAt) {
        user.availability = 'busy'
      }
    })
  }

  res.status(200).json({ serviceProviderInfo: user, service: service, reviewsDetails: reviews });
};
//#endregion

//#region change profile picture
// exports.changeProfilePic = async (req, res, next) => {
//   const userID = req.user._id;
//   const user = await User.findById(userID);
//   if (req.files) {
//     for (var i = 0; i < req.files.length; i++) {
//       if (req.files[i].fieldname === "profilePic") {
//         const result = await cloud.uploads(req.files[i].path);
//         user.profilePic = result.url;
//         fs.unlinkSync(req.files[i].path);
//         await user.save();
//       }
//     }
//   }
//   res.status(200).json({ user: user });
// };
//#endregion



//#region update profile
exports.editProfile = async (req, res, next) => {

  const { error } = validator.validateEditProfile(req.body);
  if (error)
    return res.status(400).json({
      message: error.details[0].message
    });

  try {

    let user = await User.findById(req.user._id);

    if (!user)
      return res.status(400).json({
        message: 'The User Not Found'
      });


    if (req.body.birthDate)
      req.body.age =
        new Date().getFullYear() - new Date(req.body.birthDate).getFullYear();


    req.body = _.pick(req.body, [
      'name',
      'phone_number',
      'address',
      'age',
      'gender'
    ]);


    if (req.body.address) {
      user.address = req.body.address;
      await user.save();
    }

    if (req.files) {
      for (var i = 0; i < req.files.length; i++) {
        if (req.files[i].fieldname === "profilePic") {
          const result = await cloud.uploads(req.files[i].path);
          user.profilePic = result.url;
          fs.unlinkSync(req.files[i].path);
          await user.save();
        }
      }
    }

    user = await User.findByIdAndUpdate(user._id,
      { $set: req.body },
      { new: true });


    res.status(200).json({
      status: 'Success',
      user: user
    });

  } catch (err) {
    if (err.message === "Cannot read property 'longitude' of undefined" ||
      err.message === "Cannot read property 'latitude' of undefined" ||
      err.message === "Response status code is 400") {
      return res.status(400).json({
        message: "The Address You Entered Is Not Valid",
      });
    }

    res.status(500).json({
      message: err.message
    });
  }
};
//#endregion


//#region update service data
exports.editServiceData = async (req, res, next) => {

  const { error } = validator.validateEditProfile(req.body);
  if (error)
    return res.status(400).json({
      message: error.details[0].message
    });

  try {

    let user = await User.findById(req.user._id);

    if (!user)
      return res.status(400).json({
        message: 'The User Not Found'
      });


    req.body = _.pick(req.body, [
      'serviceName',
      'servicePrice',
      'description',
    ]);

    if (user.role !== 'serviceProvider')
      return res.status(401).json({
        status: 'Failed',
        message: 'Access Denied, Only Service Providers Can Access This Page.'
      })


    await Service.findByIdAndUpdate(user.serviceId,
      { $set: req.body });


    res.status(200).json({
      status: 'Success',
      message: 'The Service Updated Successfully.'
    });

  } catch (err) {
    if (err.message === "Cannot read property 'longitude' of undefined" ||
      err.message === "Cannot read property 'latitude' of undefined" ||
      err.message === "Response status code is 400") {
      return res.status(400).json({
        message: "The Address You Entered Is Not Valid",
      });
    }

    res.status(500).json({
      message: err.message
    });
  }
};
//#endregion


//#region change email
exports.changeEmail = async (req, res, next) => {

  const { error } = validator.validateChangeEmail(req.body);
  if (error)
    return res.status(400).json({
      message: error.details[0].message
    });

  try {

    let user = await User.findById(req.user._id);

    if (!user)
      return res.status(400).json({
        message: 'The User Not Found'
      });

    req.body = _.pick(req.body, [
      'email',
      'password',
    ]);


    if (user.email === req.body.email)
      return res.status(400).json({
        status: 'Failed',
        message: 'You Can not Set Your Old Email as Your New Email.'
      });


    const checkPassword =
      await bcrypt.compare(req.body.password, user.password);


    if (!checkPassword)
      return res.status(400).json({
        status: 'Failed',
        message: 'The Password is Incorrect.'
      });

    user.email = req.body.email;

    await user.save();

    res.status(200).json({
      status: 'Success',
      message: 'The Email Changed Successfully.',
    });

  } catch (err) {
    if (err.message === "Cannot read property 'longitude' of undefined" ||
      err.message === "Cannot read property 'latitude' of undefined" ||
      err.message === "Response status code is 400") {
      return res.status(400).json({
        message: "The Address You Entered Is Not Valid",
      });
    }

    res.status(500).json({
      message: err.message
    });
  }
};
//#endregion


//#region reset password
exports.resetPassword = async (req, res, next) => {

  try {


    const { error } = validator.validateResetPassword(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });


    const user = await User.findById(req.user._id);

    if (!user)
      return res.status(400).json({
        message: 'The User Was Not Found.'
      });


    let validPassword = await bcrypt.compare(
      req.body.current_password,
      user.password
    );


    if (!validPassword)
      return res.status(400).json({ message: "Invalid password" });

    let checkNewPassword = await bcrypt.compare(
      req.body.new_password,
      user.password
    );
    if (checkNewPassword)
      return res
        .status(400)
        .json({
          message:
            "This new password is the same as your current password, Please change it",
        });


    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(req.body.new_password, salt);
    await user.save();
    res
      .status(201)
      .json({ message: "You have successfully changed your password" });

  } catch (err) {
    res.status(500).json({
      message: err.message
    })
  }
};
//#endregion




//#region Add photos in the gallery
exports.addIntoGallery = async (req, res, next) => {
  const userID = req.user._id;
  const user = await User.findById(userID);
  const service = await Service.findOne({ serviceProviderId: userID });
  if (req.files) {
    for (var i = 0; i < req.files.length; i++) {
      if (req.files[i].fieldname === "gallery") {
        let cloudStr = await cloud.uploads(req.files[i].path);
        service.gallery.push(cloudStr.url);
        await service.save();
        fs.unlinkSync(req.files[i].path);
      }
    }
  }
  res.status(200).json({ user, service });
};
//#endregion

exports.schedule = async (req, res) => {
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const serviceProviderID = mongoose.Types.ObjectId(req.params.id);

  //Getting Service Provider
  const serviceProvider = await User
    .findById(serviceProviderID)
    .populate('serviceId', 'serviceName servicePrice averageRating numberOfRatings')
    .select('name gender userName phone_number _id profilePic availability')

  //Getting The Schedule Of The Service Provider
  const schedule = await Order
    .find({ serviceProviderId: serviceProviderID, status: { $nin: ['completed', 'canceled'] } })
    .select('orderDate startsAt endsAt notes')
  if (!schedule)
    return res.status(200).json({ message: 'NO ORDERS IN THE SCHEDULE YET' });

  //Changing Avaibility Of The Service Provider Into Busy If He/She 
  let currentDate = new Date()
  currentDate.setHours(currentDate.getHours() + 2)
  schedule.map(appointment => {
    if (currentDate >= appointment.startsAt && currentDate <= appointment.endsAt) {
      serviceProvider.availability = 'busy'
    }
  })

  return res.status(200).json({ serviceProvider, schedule });
}

exports.editScheduleNotes = async (req, res) => {

}
