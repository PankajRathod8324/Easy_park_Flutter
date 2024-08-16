const mongoose = require('mongoose');
const { db } = require('./user.model');

const { Schema } = mongoose;

const vehicleSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    brand: {
        type: String,
        required: true,
    },
    model: {
        type: String,
        required: true,
    },
    seating: {
        type: String,
        required: true,
    },
    numberPlate: {
        type: String,
        required: true,
        unique: true,
    },
    bookingdetails: {
        type: Schema.Types.ObjectId,
        ref: 'parkingdetails',
    },  
    oldbookingdetails:[{
        type: Schema.Types.ObjectId,
        ref: 'parkingdetails',
    }],
});

const VehicleModel = db.model('Vehicle', vehicleSchema);

module.exports = VehicleModel;
