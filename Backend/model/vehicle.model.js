const mongoose = require('mongoose');
const { db } = require('./user.model');

const { Schema } = mongoose;

const vehicleSchema = new Schema({
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
});

const VehicleModel = db.model('Vehicle', vehicleSchema);

module.exports = VehicleModel;
