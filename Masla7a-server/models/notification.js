const mongoose = require("mongoose");
const config = require("config");
const pagination = require("mongoose-paginate-v2");

const Schema = mongoose.Schema;

const notificationSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    senderUser: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    targetUsers: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
    subjectType: {
      type: String,
    },
    subject: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: "subjectType",
    },
    seen: {
      type: Boolean,
      default: false,
    },
    icon: {
      type: String,
      default:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzsWJBiotWR7aqWNTcYyc5Xlc2TZ1VuR0k2A&usqp=CAU",
    }
  },
  { timestamps: true }
);

notificationSchema.methods.toFirebaseNotification = function () {
    return {
      notification: {
        title: this.title,
        body: this.body,
      },
    };
  };


notificationSchema.plugin(pagination);

const Notification = mongoose.model("Notification", notificationSchema);
exports.Notification = Notification;
    

