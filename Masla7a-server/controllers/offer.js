const { Offer } = require("../models/offers");
const Order = require("../models/order-model");
const User = require("../models/user-model");
const service = require("../models/service-model");
const _ = require("lodash");
const cloud = require("../images/images-controller/cloudinary");
const fs = require("fs");
const { validateOffer } = require("../validators/offer-validator");

exports.addAnOffer = async (req, res) => {
  const serviceProvider = await User.findById(req.user._id)
    .populate("serviceId", "serviceName servicePrice _id")
    .select("name profilePic _id");

  const { error } = await validateOffer(req.body);
  if (error) return res.status(400).json(error.details[0].message);

  console.log(Offer);
  let offer = await Offer.findOne({
    serviceProvider: serviceProvider._id,
    status: "Valid",
  });
  if (offer) return res.status(400).json("You already have an offer avaliable");

  const currentDate = new Date();
  currentDate.setDate(currentDate.getDate() + req.body.daysValidFor);

  const expiryDate = new Date(currentDate);
  console.log(typeof expiryDate);
  offer = await new Offer({
    serviceProvider: serviceProvider._id,
    title: req.body.title,
    description: req.body.description,
    daysValidFor: req.body.daysValidFor,
    expireAt: expiryDate,
  });
  await offer.save();
  if (req.files) {
      if (req.files[0].fieldname === "cover") {
        const result = await cloud.uploads(req.files[0].path);
        offer.cover = result.url;
        fs.unlinkSync(req.files[0].path);
        await offer.save();
    }
  }

  res.status(200).json(offer);
};

exports.fetchAllOffers = async (req, res) => {
  let offers = await Offer.find();
  const todayDate = new Date();
  offers.map(async (offer) => {
    if (offer.status === "Valid") {
      if (offer.expireAt < todayDate) {
        console.log("yaaay");
        offer.status = "Expired";
        await offer.save();
        offer = null;
      }
    }
  });
  const index = _.findKey(offers, _.matchesProperty("status", "Expired"));
  if (index !== undefined) {
    offers.splice(index, 1);
  }

  console.log(offers);

  return res.status(200).json({ offers });
};
