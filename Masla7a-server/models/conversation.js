const mongoose = require("mongoose");
const pagination = require('mongoose-paginate-v2')

const conversationSchema = new mongoose.Schema(
  {
    users: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
    lastMessage: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
  },
  { timestamps: true }
);
// conversationSchema.set("toJSON", {
//     virtuals: true,
//     transform: function (doc) {
//       return {
//         id: doc.id,
//         users: doc.users,
//         lastMessage: doc.lastMessage,
//         createdAt: doc.createdAt,
//         updatedAt: doc.updatedAt,
//       };
//     },
//   });

conversationSchema.plugin(pagination);

const Conversation = mongoose.model("Conversation", conversationSchema);
exports.Conversation = Conversation;
