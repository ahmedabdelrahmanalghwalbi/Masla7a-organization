const mongoose = require('mongoose');

const complaintSchema = new mongoose.Schema({
    serviceProvider: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    complaintType: {
        type: String,
        enum: ['Bad Behaviuor', 'High Prices', 'Delay','Caused Damage','Others'],
        required: true
    },
    description: {
        type: String,
        required: true
    },
},
{timestamps:true}
);


module.exports = mongoose.model('Complaint', complaintSchema);