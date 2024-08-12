const ReviewModel = require('../model/reviewdetails.model');
const ParkAreaModel = require('../model/parkarea.model');
exports.addReview = async ({ username, date, rating, review ,ParkAreaId }) => {
  try {
    // Create a new review document
    const newReview = new ReviewModel({
      username,
      date,
      rating,
      review,
    });
    console.log("Booking Data:", newReview); 

    await ParkAreaModel.findByIdAndUpdate(
      ParkAreaId,
      { $push: { reviewdetails: newReview._id } },
      { new: true }
    );
    // Save the review to the database
    await newReview.save();
  } catch (error) {
    throw error;
  }
};
