const mongoose = require('mongoose');
const { db } = require('./user.model');

const { Schema } = mongoose;

const vehicleSchema = new Schema({
<<<<<<< HEAD
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
    bookingdetails: {
        type: Schema.Types.ObjectId,
        ref: 'parkingdetails',
    },  
    oldbookingdetails:[{
        type: Schema.Types.ObjectId,
        ref: 'parkingdetails',
    }],
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
});

const VehicleModel = db.model('Vehicle', vehicleSchema);

<<<<<<< HEAD
module.exports = VehicleModel;
=======
module.exports = VehicleModel;
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
