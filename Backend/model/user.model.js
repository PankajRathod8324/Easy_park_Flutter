const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

const { Schema } = mongoose;

const userSchema = new Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
    },
    vehicles: [{
        type: Schema.Types.ObjectId,
        ref: 'Vehicle',
    }],
<<<<<<< HEAD
    profile: { type: String },
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
});

userSchema.pre('save', async function (next) {
    try {
        var user = this;

        // Check if the password field is modified
        if (user.isModified('password')) {
            const salt = await bcrypt.genSalt(10);
            const hashpass = await bcrypt.hash(user.password, salt);
            user.password = hashpass;
        }
        next();
    } catch (e) {
        next(e);
    }
});

const UserModel = db.model('user', userSchema);

module.exports = UserModel;
