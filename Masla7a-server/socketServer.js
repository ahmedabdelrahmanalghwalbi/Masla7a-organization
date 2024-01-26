const socketIO = require("socket.io");
const socketIOJwt = require("socketio-jwt");
const mongoose = require("mongoose");
const { Conversation } = require("./models/conversation");
const { Notification } = require("./models/notification");
const Message = require("./models/messages").Message;
const User = require("./models/user-model");
const Order = require("./models/order-model");
const multerconfig = require("./images/images-controller/multer");
const cloud = require("./images/images-controller/cloudinary");
const config = require("config");
const fs = require("fs");

const socketServer = (server) => {
  try {
    const io = socketIO(server);

    //#region socket nameSpace and Athenticating
    const nameSpace = io.of("/chatting");
    nameSpace.on(
      "connection",
      socketIOJwt.authorize({
        secret: config.get("jwtPrivateKey"),
      }),
      (socket) => {
        socket.emit("Hello from rim, you have connected successfully");
      }
    );
    //#endregion

    //Authenticate event
    nameSpace.on("authenticated", async (socket) => {
      console.log("successfuly authenticated");

      //#region Extracting sender id and joining a room
      const senderID = socket.decoded_token._id;
      await socket.join(`user ${senderID}`);
      socket.emit("hello", "Hello from rim, you have connected successfully");
      //#endregion

      //Private event
      socket.on("private", async (data) => {
        console.log(data);
        if (!data.content && !data.attachment && !data.type) return;
        const senderID = socket.decoded_token._id;

        //#region Return conversation if there is and create one if there isn't
        console.log("hello");
        let conversation = await Conversation.findOne({
          $or: [{ users: [senderID, data.to] }, { users: [data.to, senderID] }],
        });

        //Create a conversation if there isn't
        if (!conversation) {
          conversation = await new Conversation({
            users: [senderID, data.to],
          });
          await conversation.save();
        }
        //#endregion

        console.log(typeof senderID);
        const sender = await User.findById(mongoose.Types.ObjectId(senderID));
        let emittedData;
        let sentMessage;
        if (data.type !== "order") {
          //#region saving messages to the Database
          sentMessage = await new Message({
            user: senderID,
            content: data.content,
            attachment: data.attachment,
            type: 'text',
            conversation: conversation._id,
          });
          await sentMessage.save();

          console.log(sentMessage._id);
          conversation.lastMessage = await sentMessage._id;
          await conversation.save();

          emittedData = {
            messageID: sentMessage._id,
            content: data.content,
            sender: senderID,
            type: 'text',
            createdAt: sentMessage.createdAt,
            role: sender.role,
            conversationID: conversation._id
          };
        }
        //#endregion

        //#region Emmitting order data for forms
        else {
          let serviceProviderID;
          let customerID;
          if (sender.role === "serviceProvider") {
            serviceProviderID = sender._id;
            customerID = data.to;
          } else {
            serviceProviderID = data.to;
            customerID = sender._id;
          }
          const order = await Order.findById(mongoose.Types.ObjectId(data.content))
            .select(
              "-serviceProviderId -customerId -serviceId -notes -status "
            );
          if (!order) return;
          emittedData = { order, role: sender.role, senderID: sender._id, dataType:'order', receiverId: data.to };
        }
        //#endregion
        nameSpace
          .to(`user ${data.to}`)
          .to(`user ${senderID}`)
          .emit("new-message", emittedData);
        console.log(emittedData);

        //#region  Send Notification
        //in-app Notification
        const receiver = await User.findById(data.to);
        if (sentMessage) {
          const notification = await new Notification({
            title: "New Message",
            body: data.content,
            senderUser: senderID,
            targetUsers: data.to,
            subjectType: "Message",
            subject: sentMessage._id,
          }).save();
          // push notifications
          await receiver.user_send_notification(
            notification.toFirebaseNotification()
          );
        }

        //#endregion
        console.log("CHECK POINT WOOHOOO..");
      });
      socket.on("decline", async (data) => {
        if (!data.to) {
          console.log("Receiver ID Should be sent");
          return;
        }
        const senderID = socket.decoded_token._id;
        const sender = await User.findById(mongoose.Types.ObjectId(senderID));
        let serviceProviderID;
        let customerID;
        if (sender.role === "serviceProvider") {
          serviceProviderID = sender._id;
          customerID = data.to;
        } else {
          serviceProviderID = data.to;
          customerID = sender._id;
        }
        const order = await Order.findOneAndRemove({
          serviceProviderId: serviceProviderID,
          customerId: customerID,
          status: "pending",
        }).sort("-createdAt");
        let conversation = await Conversation.findOne({
          $or: [{ users: [senderID, data.to] }, { users: [data.to, senderID] }],
        });
        let sentMessage = await new Message({
          user: senderID,
          content:  `${sender.name} Declined The Order`,
          type: 'text',
          conversation: conversation._id,
        });
        await sentMessage.save();
        conversation.lastMessage = await sentMessage._id;
          await conversation.save();

        nameSpace
          .to(`user ${data.to}`)
          .to(`user ${senderID}`)
          .emit("new-message",{content:sentMessage.content, type:'cancelation',senderID:senderID,dataType:'text', createdAt:sentMessage.createdAt});
      });
      socket.on("acceptance", async (data) => {
        if (!data.to) {
          console.log("Receiver ID Should be sent");
          return;
        }
        const senderID = socket.decoded_token._id;
        const sender = await User.findById(mongoose.Types.ObjectId(senderID));
        let serviceProviderID;
        let customerID;
        if (sender.role === "serviceProvider") {
          serviceProviderID = sender._id;
          customerID = data.to;
        } else {
          serviceProviderID = data.to;
          customerID = sender._id;
        }
        let conversation = await Conversation.findOne({
          $or: [{ users: [senderID, data.to] }, { users: [data.to, senderID] }],
        });
        let sentMessage = await new Message({
          user: senderID,
          content: `${sender.name} Accepted The Order`,
          type: 'text',
          conversation: conversation._id,
        });
        await sentMessage.save();
        conversation.lastMessage = await sentMessage._id;
          await conversation.save();
        nameSpace
          .to(`user ${data.to}`)
          .to(`user ${senderID}`)
          .emit("new-message", {content:sentMessage.content, type:'acceptance',senderID:senderID, dataType:'text', createdAt:sentMessage.createdAt});
      });
      socket.on("files", async (data) => {
  const conversation= await Conversation.findById(mongoose.Types.ObjectId(data.conversationID))
        const message = await Message.findOne({conversation:conversation._id, type:'image'}).sort('-createdAt')
        const senderID = socket.decoded_token._id;
        const sender = await User.findById(mongoose.Types.ObjectId(senderID));
        nameSpace
          .to(`user ${data.to}`)
          .to(`user ${senderID}`)
          .emit("new-message", {attachment:message.attachment, type:'files', dataType:'image', createdAt: message.createdAt, senderID:senderID});
      });
    });

    return io;
  } catch (error) {
    console.log("error...We are at catch");
  }
};
exports.socketServer = socketServer;
