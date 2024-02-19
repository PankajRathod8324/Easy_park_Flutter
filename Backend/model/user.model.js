const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');


const { Schema } = mongoose;

const userSchema = new Schema({
    email:{
        type: 'string',
        lowercase: true,
        required: true,
        unique:true,
    },
    password:{
        type: 'string',
        required: true,
    }

})

userSchema.pre('save',async function(){
    try{
        var user = this ;
        const salt = await (bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);
        user.password = hashpass;
    }catch(e){
        throw e;
    }

})

const UserModel = db.model('user  ',userSchema);

module.exports = UserModel;