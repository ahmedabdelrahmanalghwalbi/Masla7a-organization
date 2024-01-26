const express = require("express");
const mongoose = require("mongoose");
const config = require("config");
const cors = require('cors');
const authRouter = require('./routes/user-auth-routes');
const categoryRouter = require('./routes/category-routes');
const conversationRouter = require('./routes/conversation');
const adminRoute = require('./routes/admin')
const homeRoute = require('./routes/home')
const userProfile = require('./routes/profile');
const orderRouter = require('./routes/order-routes');
const favouritesRouter = require('./routes/favourites-routes');
const notificationRouter = require('./routes/notification');
const requestRouter = require('./routes/request');
const offerRouter = require('./routes/offer');
const { handlingError, serverErrorHandler, _404 } = require('./controllers/error')


const app = express();

const port = process.env.PORT || 3000;
const uri =
  "mongodb+srv://masla7a_team:TcFX4tnzWH8HlQZq@cluster0.7ygwl.mongodb.net/maslaha?retryWrites=true&w=majority";

var corsOption = {
  origin: true,
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  exposedHeaders: ['x-auth-token']
};

// /home/top-workers

app.use(cors(corsOption));

app.use(express.json());
app.use(express.urlencoded({extended: true}));

app.use('/admin/control', adminRoute);
app.use('/home', homeRoute);
app.use('/accounts', authRouter);
app.use('/orders', orderRouter);
app.use('/my-profile', userProfile);
app.use('/chatting', conversationRouter);
app.use('/categories', categoryRouter);
app.use('/favourites', favouritesRouter);
app.use('/notifications', notificationRouter)
app.use('/request', requestRouter);
app.use('/offer', offerRouter);
app.use('/', _404);
// app.use(handlingError, serverErrorHandler)
// app.use(serverErrorHandler)



if (!config.get("jwtPrivateKey")) {
  console.log("This is FATAL, Private key is not defined");
  process.exit(1);
}


mongoose
  .connect(uri, {
    useUnifiedTopology: true,
    useNewUrlParser: true,
    useCreateIndex: true,
  })
  .then(() => {
    console.log("Connected to MongoDB...");
    const server = app.listen(port, console.log(`Listening to port ${port}`));

    server.on("error", function (err) {
      console.error(err.message.red);
    });


    require("./socketServer").socketServer(server);
  })
  .catch((err) => console.log(err.message));