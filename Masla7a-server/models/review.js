const mongoose = require("mongoose");
const Service = require('../models/service-model');
const pagination = require("mongoose-paginate-v2");

const reviewSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true
    },
    content: {
        type: String,
        trim: true,  
        required: true,
    },
    rating: {
        type: Number,
        required:true,
        min: 1,
        max:5
    },
    serviceID: {
        type: mongoose.Schema.ObjectId,
        ref: "Service",
        required:true
    },
    user: {
        type: mongoose.Schema.ObjectId,
        ref: "User",
        required:true
    },
    createdAt: {
        type: Date,
        default:Date.now(),
    }
});
reviewSchema.index({ service: 1, user: 1 }, { uniqe: true });

reviewSchema.plugin(pagination)

//static methods to get average rating of reviews
reviewSchema.statics.getAverageRating = async function (service_ID) {
    const avgObject = await this.aggregate([
        {
            $match: { serviceID: service_ID },
            
        },
        {
            $group: {
                _id: '$serviceID',
                number_of_ratings: {$sum : 1},
                avgRating:{$avg:'$rating'}
            }
        }
    ]);
    try {
       const service = await Service.findByIdAndUpdate(service_ID, {
            numberOfRatings :avgObject[0].number_of_ratings, 
            averageRating:avgObject[0].avgRating
        });
    } catch (ex) {
        console.error(ex);
    }
}
reviewSchema.post('save', function(next){
    this.constructor.getAverageRating(this.serviceID)
})

reviewSchema.post('remove', async function(){
    await this.constructor.getAverageRating(this.serviceID)
})

module.exports = mongoose.model('Review', reviewSchema);