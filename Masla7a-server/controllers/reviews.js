const Review = require("../models/review");
const Service = require("../models/service-model");
const User = require("../models/user-model");
const {Notification} = require("../models/notification");
const mongoose = require("mongoose");
const _ = require("lodash");
const { validateReview } = require("../validators/review-validator");

exports.getAllServiceReviews = async (req, res, next) => {
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const serviceProviderID = mongoose.Types.ObjectId(req.params.id);
  const service = await Service.findOne({
    serviceProviderId: serviceProviderID,
  });

  if(!service)
  return res.status(400).json({message: 'There is no service provider with such ID'})
  const reviews = await Review.find({ serviceID: service._id })
  .populate("user", "name profilePic -_id")
  .select('title content rating _id')

if (reviews) {
    res.status(200).json({
      reviews: reviews,
      rate: service.averageRating,
      number_of_rates: service.numberOfRatings,
      //reviewer: reviewer
    });
  } else {
    res.status(200).json({
      message: "No Reviews Yet",
    });
  }
};

exports.postServiceReview = async (req, res, next) => {
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const serviceProviderID = mongoose.Types.ObjectId(req.params.id);
  
  //Retriving The Service from the Service Model
  const service = await Service.findOne({
    serviceProviderId: serviceProviderID,
  });
  //Retriving Back The Reviewer and The Service Provider From User Model
  const reviewer = await User.findById(req.user._id);
  const serviceProvider = await User.findById(serviceProviderID);

  //Validating The Input Review
  const { error } = validateReview(req.body);
  if (error) return res.status(401).json(error.details[0].message);

  //Checking If The Reviewer Has Already Reviewed The User
  const redundantReview = await Review.findOne({
    serviceID: service._id,
    user: req.user._id,
  });
  if (redundantReview)
    return res
      .status(400)
      .json({ message: "You Have Already Reviewed This Service" });

  const review = await Review.create({
    title: req.body.title,
    content: req.body.content,
    rating: req.body.rating,
    serviceID: service._id,
    user: reviewer._id,
  });
  try {
    try{
      //Saving in-app notification for the request
      const notification = await new Notification({
          title: "New Review",
          body: `User ${reviewer.name} Reviewed Your ${ service.serviceName} Service `,
          senderUser: reviewer._id,
          targetUsers:  serviceProviderID,
          subjectType: "Review",
          subject: review._id,
        })
        await notification.save();
  
      //push firebase notification
      await serviceProvider.user_send_notification(
          notification.toFirebaseNotification()
        );
  
    }catch(err){
     console.log(err)
    }
    await review.save();
    res.status(200).json({
      message: "Successfully added a review",review
    });
  } catch (err) {
    res.status(400).json({
      message: "Didn't Post A Review Successfully",
    });
  }
  
};

exports.updateMyReview = async(req, res, next)=>{
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const { error } = validateReview(req.body);
  if (error) return res.status(401).send(error.details[0].message);

  const reviewID = mongoose.Types.ObjectId(req.params.id);

  let review = await Review.findById(reviewID);
  if(!review)
  return res.status(400).json({message :'There Is No Review With Such ID'});

  if(review.user != req.user._id)
  return res.status(401).json('You cannot update this review..')
 
   review = await Review.findByIdAndUpdate(reviewID, req.body,{new:true});

 await review.save();
  res.status(200).json({message: 'updated Successfully',review})
}



exports.deleteMyReview = async(req, res, next)=>{
  if (req.params.id.length != 24) return res.status(404).send("Invalid ID");

  const reviewID = mongoose.Types.ObjectId(req.params.id);
  const review = await Review.findById(reviewID);
  
  if(!review)
  return res.status(400).json({message :'There Is No Review With Such ID'});

  console.log("review user id "+review.user+' request user id'+req.user._id)
  if(review.user != req.user._id)
  return res.status(401).json('You cannot delete this review..')
 
 await review.remove();
  res.status(200).json({message: 'Deleted Successfully'})
}

