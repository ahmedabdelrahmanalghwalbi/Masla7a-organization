const { Notification } = require('../models/notification')
const notificationService = require('../services/notification')
const User = require('../models/user-model');
const _ = require("lodash");
const mongoose = require('mongoose');

exports.fetchAllNotifications = async (req, res) => {
  const user = req.user;

  let notifications = await Notification.find({
    targetUsers: { $in: [user._id] },
  })
    .populate('senderUser', 'name profilePic _id')
    .sort("-createdAt")

  for (let i = 0; i < notifications.length; i++) {
    let notification = _.cloneDeep(notifications[i]);
    if (notification.seen) continue;
    notification.seen = true;
    await notification.save();
  }
  return res.status(200).json({ notifications: notifications });
};

exports.numberOfUnseen = async (req, res) => {
  const user = req.user
  const numberOfUnseen = await Notification.countDocuments({
    targetUsers: user._id,
    seen: false
  });

  return res.status(200).json({
    unseenCount: numberOfUnseen
  })
}

exports.sendNotification = async (req, res) => {
  const deviceToken = req.body.deviceToken;
  const message = {
    notification: {
      title: req.body.title,
      body: req.body.title
    }
  }
  await notificationService.firebaseSendNotification(deviceToken, message);
};


exports.deleteNotification = async (req, res) => {

  if (!mongoose.isValidObjectId(req.params.notificationId))
    return res.status(400).json({
      status: 'Failed',
      message: 'Notification ID is Invalid'
    });


  try {
    let notification = await Notification
      .findById(req.params.notificationId);

    if (!notification)
      return res.status(400).json({
        status: 'Failed',
        message: 'The Notification You are Trying To Delete Does not Exist'
      });



    if (!notification.targetUsers.includes(req.user._id))
      return res.status(400).json({
        status: 'Failed',
        message: 'You are not allowed to deleteThis Notification',
      });

    await Notification.findByIdAndDelete(req.params.notificationId);

    return res.status(200).json({
      status: 'Success',
      message: 'Notification Deleted Succefully'
    });

  } catch (err) {
    res.status(500).json({
      message: err.message
    });
  }
}

exports.subscribe = async (req, res) => {
  const user = await User.findById(req.user._id);

}