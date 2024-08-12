const ReviewService = require('../services/reviewdetails.services');

exports.addReview = async (req, res) => {
  try {
    // Log the request body for debugging
    console.log('Request Body:', req.body);

    const { username, date, rating, review ,ParkAreaId } = req.body;
    await ReviewService.addReview({ username, date, rating, review ,ParkAreaId});
    res.status(201).json({ message: 'Review added successfully' });
  } catch (error) {
    console.error('Error adding review:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const ReviewModel = require('../model/reviewdetails.model');
const ParkArea = require('../model/parkarea.model');

exports.getreview = async (req, res) => {
  try {
    // Extract the parkAreaId from the request parameters
    const { parkAreaId } = req.query;
    console.log(parkAreaId);
    // Validate if parkAreaId is provided
    if (!parkAreaId) {
      return res.status(400).json({ error: 'Park area ID is required' });
    }

    // Find the park area by its ID
    const parkArea = await ParkArea.findById(parkAreaId).populate('reviewdetails');
    console.log(parkArea);
    // Check if the park area exists
    if (!parkArea) {
      return res.status(404).json({ error: 'Park area not found' });
    }

    // Extract reviews associated with the park area
    const reviews = parkArea.reviewdetails;
    
    // If no reviews are found, return a 404 Not Found response
    if (reviews.length === 0) {
      return res.status(404).json({ error: 'No reviews found for this park area' });
    }
    console.log(reviews);
    // If reviews are found, send them back to the frontend
    res.status(200).json({ reviews });
  } catch (error) {
    // Handle any errors that occur during the process
    console.error('Error fetching review details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

