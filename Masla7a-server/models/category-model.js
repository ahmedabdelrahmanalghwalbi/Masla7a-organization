const mongoose = require('mongoose');


const categorySchema = new mongoose.Schema({
    name: {
        type: String,
        minlength: 3,
        maxlength: 55,
        trim: true,
        required: true,
        unique: true
    },
    servicesList: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service',
        required: true
    }],
    icon:{
        type: String,
        required: true
    },
    coverPhoto:{
        type: String,
        required: true
    },
});




module.exports = mongoose.model('Category', categorySchema);