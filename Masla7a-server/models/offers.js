const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const offerSchema = new Schema(
  {
    serviceProvider: {
      type: mongoose.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description:{
      type:String,
      required:true
    },
    cover:{
      type:String
    },
    daysValidFor: {
      type: Number,
      required: true,
    },
    expireAt:{
      type:Date,
      required:true
    },
    status:{
      type:String,
      enum: ['Valid','Expired'],
      required: true,
      default: 'Valid'
    }
  },
  { timestamps: true }
);

const Offer = mongoose.model("Offer", offerSchema);
exports.Offer = Offer
