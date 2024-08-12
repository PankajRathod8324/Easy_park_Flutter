const db = require('../config/db');
const mongoose = require('mongoose');

const { Schema } = mongoose;

const bookingdetailsSchema = new Schema({
    vehicle: {
        type: Schema.Types.ObjectId,
        ref: 'Vehicle', // Reference to the Vehicle model
        required: true
    },
    parkArea: {
        type: Schema.Types.ObjectId,
        ref: 'ParkArea', // Reference to the ParkArea model
        required: true
    },
    startTime: {
        type: Date,
        required: true
    },
    endTime: {
        type: Date,
        required: true
    },
    bookingDate: {
        type: Date,
        required: true
    },
    status: {
        type: String,
        enum: ['Booked', 'Cancelled', 'Completed'], // Enum to represent different statuses
        required: true
    },
    totalPrice: {
        type: Number,
        require: true

    },
    slot: {
        type: String,
        required: true,
    }
    // You can add more fields as needed
});

const BookingDetails = db.model('bookingdetails', bookingdetailsSchema);

module.exports = BookingDetails;
