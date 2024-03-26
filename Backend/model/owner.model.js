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
    image: { type: String, required: true },
    password: {
        type: String,
        required: true,
    },
    parkingAreas: [{ type: Schema.Types.ObjectId, ref: 'ParkArea' }],
    
});

ownerSchema.pre('save', async function (next) {
    try {
        const owner = this;

        // Check if the password field is modified or if the document is new
        if (!owner.isModified('password')) {
            return next();
        }

        const salt = await bcrypt.genSalt(10);
        const hashpass = await bcrypt.hash(owner.password, salt);
        owner.password = hashpass;

        return next();
    } catch (e) {
        return next(e);
    }
});

const OwnerModel = db.model('Owner', ownerSchema);

module.exports = OwnerModel;