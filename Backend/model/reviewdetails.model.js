const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const reviewSchema = new Schema({
  username: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    required: true,
    default: Date.now,
  },
  rating: {
    type: Number,
    required: true,
  },
  review: {
    type: String,
    required: true,
  },
});

const ReviewModel = db.model('Review', reviewSchema);

module.exports = ReviewModel;
