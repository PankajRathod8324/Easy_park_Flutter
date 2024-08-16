const mongoose = require('mongoose');
const { Schema } = mongoose;
const { db } = require('./owner.model');

const parkAreaSchema = new Schema({
    location: {
        latitude: { type: Number, required: true },
        longitude: { type: Number, required: true },
    },
    name: {type: String , required: true},
    pincode: { type: String, required: true },
    images: [{ type: String }], // Assuming you want to store image URLs
    phone: { type: String, required: true },
    slots: { type: Number, required: true }, // Number of available slots
    address: { type: String, required: true },
    timing: { type: String, required: true },
    owner: { type: Schema.Types.ObjectId, ref: 'Owner', required: true }, // Reference to Owner model
    bookingdetails: [{ type: Schema.Types.ObjectId, ref: 'BookingDetails' }],
    price_per_hr: { type: Number, required: true },
    boocked_slots: [{ type: String }],
    reviewdetails: [{type: Schema.Types.ObjectId, ref: 'Review'}], 
    oldbookingdetails: [{ type: Schema.Types.ObjectId, ref: 'BookingDetails' }],

    pincode: { type: String, required: true },
    images: [{ type: String }], // Assuming you want to store image URLs
    phone: { type: String, required: true },
    slots: { type: Number, default: 0 }, // Number of available slots
    address: { type: String, required: true },
    timing: { type: String, required: true },
    owner: { type: Schema.Types.ObjectId, ref: 'Owner', required: true }, // Reference to Owner model
});

const ParkArea = db.model('ParkArea', parkAreaSchema);

module.exports = ParkArea;
