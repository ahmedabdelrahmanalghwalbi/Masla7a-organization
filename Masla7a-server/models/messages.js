const mongoose = require('mongoose')
const config = require('config')
const jwt = require('jsonwebtoken')
const pagination = require('mongoose-paginate-v2')

const Schema = mongoose.Schema;

const messageSchema = new Schema({
    content: {
      type: String,
    },
    attachment: {
      type: String,
    },
    type:{
      type:String,
      enum:['text','image','order']
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", 
      required: true,
    },
    conversation: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Conversation",
      required: true,
    },
  },
  { timestamps: true }
);

messageSchema.plugin(pagination);

const Message = mongoose.model("Message", messageSchema);

exports.Message = Message
