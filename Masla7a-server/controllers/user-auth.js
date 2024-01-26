const User = require("../models/user-model");
const Service = require("../models/service-model");
const Category = require("../models/category-model");
const validator = require("../validators/user-validator");
const config = require("config");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const cloud = require("../images/images-controller/cloudinary");
const fs = require("fs");

//#region handling common functions
const addUser = async (req, res) => {
  //Creating a User
  const today = new Date();
  const userDate = new Date(req.body.birthDate);
  const age = today.getFullYear() - userDate.getFullYear();

  const user = new User({
    name: req.body.name,
    email: req.body.email,
    password: req.body.password,
    age: age,
    nationalID: req.body.nationalID,
    phone_number: req.body.phone_number,
    gender: req.body.gender,
    userName: req.body.userName,
    role: req.body.role,
    address: req.body.address,
  });
  if (req.body.deviceToken) {
    let pushToken = {
      deviceToken: req.body.deviceToken
    }
    await user.pushTokens.push(pushToken);
  }
  // Reading files
  if (req.files) {
    for (var i = 0; i < req.files.length; i++) {
      if (req.files[i].fieldname === "profilePic") {
        const result = await cloud.uploads(req.files[i].path);
        user.profilePic = result.url;
        fs.unlinkSync(req.files[i].path);
      }
    }
  }
  //Encrypting the password
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);

  await user.save();
  return user;
};
//#endregion

//#region User Sign up
exports.addingUser = async (req, res, next) => {
  try {
    let user;

    if (Object.keys(req.body).length === 0)
      return res
        .status(400)
        .json({ message: "Error Message...The Request Body Is Empty!" });

    //Normal User Handling
    if (req.body.role === "customer") {
      const { error } = validator.validateSignUp(req.body);
      if (error)
        return res.status(400).json({ message: error.details[0].message });

      user = await User.findOne({ email: req.body.email });

      if (user)
        return res.status(400).json({
          message: `This Email has been registered before as ${user.role}`,
        });

      user = await User.findOne({ userName: req.body.userName });

      if (user)
        return res.status(400).json({
          message: "This userName is already used, choose another one",
        });

      user = await addUser(req, res);
    }

    //Service Provider and Service Handling
    if (req.body.role === "serviceProvider") {
      const { error } = validator.validateServiceProvider(req.body);
      if (error)
        return res.status(400).json({ message: error.details[0].message });

      user = await User.findOne({ email: req.body.email });

      if (user)
        return res.status(400).json({
          message: `This Email has been registered before as ${user.role}`,
        });

      user = await User.findOne({ userName: req.body.userName });

      if (user)
        return res.status(400).json({
          message: "This userName is already used, choose another one",
        });

      //Adding service
      const category = await Category.findOne({ name: req.body.category });

      if (!category)
        return res.status(400).json({
          message: "The Category You Chose Is Not Valid",
        });

      user = await addUser(req, res);

      const service = await Service({
        serviceName: req.body.serviceName,
        categoryId: category._id,
        serviceProviderId: user._id,
        servicePrice: req.body.servicePrice,
        description: req.body.description,
      }).save();

      category.servicesList.push(service._id);

      await category.save();

      user.serviceId = service._id;

      if (req.files) {
        for (var i = 0; i < req.files.length; i++) {
          if (req.files[i].fieldname === "gallery") {
            let cloudStr = await cloud.uploads(req.files[i].path);
            service.gallery.push(cloudStr.url);
            fs.unlinkSync(req.files[i].path);
          }
        }
      }

      await service.save();

      await user.save();
    }

    if (!user)
      return res
        .status(400)
        .json({ message: "Failed to submit a user successfully" });
    //Sending genereted token
    let token = user.generateAuthToken();

    res
      .header("x-auth-token", token)
      .status(200)
      .json({
        token: token,
        user: _.pick(user, ["_id", "name", "email", "role", "gotAddress"]),
      });
  } catch (err) {
    if (err.message === "Cannot read property 'longitude' of undefined" ||
      err.message === "Cannot read property 'latitude' of undefined" ||
      err.message === "Response status code is 400") {
      return res.status(400).json({
        message: "The Address You Entered Is Not Valid",
      });
    }
    res.status(500).json({
      message: err.message,
    });
  }
};
//#endregion

//#region Extracting Token Data
exports.extractingToken = async (req, res, next) => {
  //getting value from a header by giving its key
  const token = req.header("x-auth-token");
  if (!token)
    return res.status(401).send("Access denied. No token is avaliable.");
  try {
    //Transfer the data in the token into a meaningful data
    const decoded = jwt.verify(token, config.get("jwtPrivateKey"));

    //Setting the body of the user into the body decoded from the token
    req.user = decoded;
    next();
  } catch (ex) {
    res.status(400).send("Invalid Token");
  }
};

//#endregion

//#region Login a user by using JWT
exports.authUser = async (req, res, next) => {
  console.log(req.body);

  const { error } = validator.validateLogIn(req.body);
  if (error) return res.status(401).send(error.details[0].message);

  let user = await User.findOne({ email: req.body.email });
  if (!user || user.role === 'admin') return res.status(400).send("Invalid email or password");

  let validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).send("Invalid email or password");

  const token = await user.generateAuthToken();

  res.status(200).json({ token: token, _id: user._id });
};
//#endregion
