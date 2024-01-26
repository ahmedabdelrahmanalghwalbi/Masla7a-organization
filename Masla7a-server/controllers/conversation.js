const { Conversation } = require("../models/conversation");
const { Message } = require("../models/messages");
const _ = require("lodash");
const cloud = require("../images/images-controller/cloudinary");
const fs = require("fs");
const mongoose = require('mongoose')
 //status

exports.fetchAll = async (req, res, next) => {
  const conversations = await Conversation.find(
    { users: req.user._id, lastMessage:{$nin:null} },
  )
  .populate('users lastMessage','name profilePic role availability user attachment type content createdAt')
  .sort('-updatedAt')
  .select('-createdAt -updatedAt')
  res.status(200).json(conversations);
}; 

exports.fetchMessages = async (req, res, next) => {

  if(req.body.id.length != 24 )
  return res.status(404).json("Invalid ID");

  const conversationID = mongoose.Types.ObjectId(req.body.id)
  const conversation = await Conversation.findById(conversationID);
  if (!conversation)
    return res.status(404).json("No conversation with such ID");

  const messages = await Message.find(
    {
      conversation: conversationID,
    }
  ).populate('user', 'name profilePic')
  .select('content attachment createdAt type')
  .sort('-createdAt');

  res.status(200).json(messages);
};

exports.deleteConversation = async(req, res, next)=>{
  if (req.params.id.length != 24) return res.status(404).json("Invalid ID");

  const conversationID = mongoose.Types.ObjectId(req.params.id);
  const conversation = await Conversation.findById(conversationID);
  
  if(!conversation)
  return res.status(400).json({message :'There Is No conversation With Such ID'});

  const messages = await Message.find({conversation:conversationID});
  messages.map(message=>{
    message.remove()
  })
  //service, price, data //tare5 l order,startTime, endTime, notes,  
  console.log(messages)
  await conversation.remove();
  
  res.status(200).json({message: 'Deleted Successfully'})
}

exports.addImage = async (req, res)=>{
  if(!req.body.conversationID)
  return res.status(400).json('Incomplete Data');
  
  const conversation= await Conversation.findById(mongoose.Types.ObjectId(req.body.conversationID))
 if(!conversation)return res.status(400).json('no conversation with such id')
  const message = new Message({
    type:'image',
    user: req.user._id,
    conversation: conversation._id,
  });
  if (req.files) {
    if (req.files[0].fieldname === "image") {
      const result = await cloud.uploads(req.files[0].path);
      message.attachment = result.url;
      fs.unlinkSync(req.files[0].path);
      await message.save();
    }
  }
  return res.status(200).json({sender:req.user._id, conversation:conversation._id , message })
}