const db = require('../config/db');
const bcrypt = require('bcrypt');
const mongoose = require('mongoose');

const { Schema } = mongoose;

const ownerSchema = new Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
    },
    location: {
        latitude: { type: Number, required: true },
        longitude: { type: Number, required: true },
    },
    image: { type: String, required: true },
    password: {
        type: String,
        required: true,
    },
});

// ownerSchema.index({ location: '2dsphere' }); // Index for geospatial queries

ownerSchema.pre('save', async function () {
    try {
        const owner = this;
        const salt = await bcrypt.genSalt(10);
        const hashpass = await bcrypt.hash(owner.password, salt);
        owner.password = hashpass;
    } catch (e) {
        throw e;
    }
});

const OwnerModel = db.model('Owner', ownerSchema);

module.exports = OwnerModel;


// owner.model.js

// const { Schema } = mongoose;

// const ownerSchema = new Schema({
//   name: { type: String, required: true, index: true },
//   image: { type: String, required: true },
// });

// const OwnerModel = db.model('Owner', ownerSchema);

// module.exports = OwnerModel;


// first model

// // const mongoose = require('mongoose');
// // const db = require('../config/db');
// // const bcrypt = require('bcrypt');

// // const { Schema } = mongoose;

// // const ownerSchema = new Schema({
// //     name: {
// //         type: String,
// //         required: true,
// //     },
// //     email: {
// //         type: String,
// //         lowercase: true,
// //         required: true,
// //         unique: true,
// //     },
// //     phone: {
// //         type: String,
// //         required: true,
// //     },
// //     location: {
// //         type: {
// //             type: String,
// //             enum: ['Point'],
// //             default: 'Point',
// //         },
// //         coordinates: {
// //             type: [Number],
// //             required: true,
// //         },
// //     },
// //     image: {
// //         type: String,
// //         required: false, // Adjust as needed
// //     },
// //     password: {
// //         type: String,
// //         required: true,
// //     },
// // });

// // // ownerSchema.index({ location: '2dsphere' }); // Index for geospatial queries

// // ownerSchema.pre('save', async function () {
// //     try {
// //         const owner = this;
// //         const salt = await bcrypt.genSalt(10);
// //         const hashpass = await bcrypt.hash(owner.password, salt);
// //         owner.password = hashpass;
// //     } catch (e) {
// //         throw e;
// //     }
// // });

// // const OwnerModel = db.model('Owner', ownerSchema);

// // module.exports = OwnerModel;

// const mongoose = require('mongoose');

