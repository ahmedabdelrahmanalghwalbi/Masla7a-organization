const admin = require("firebase-admin");

const serviceAccount = require("../config/firebaseServiceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

exports.firebaseSendNotification = async (token, message)=> {
    message.token = token;
    return await admin.messaging().send(message);
};
