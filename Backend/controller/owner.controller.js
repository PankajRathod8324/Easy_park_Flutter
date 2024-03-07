const OwnerModel = require('../model/owner.model');
const OwnerService = require('../services/owner.services');

exports.register = async (req, res, next) => {
  try {
    const { name, email, phone, password } = req.body;
    const locationString = req.body.location;
    const location_obj = JSON.parse(locationString); // Convert the string to an array
    const latitude = location_obj[0][0];
    const longitude = location_obj[0][1];

    // Check for missing fields
    if (!name || !email || !phone || !latitude || !longitude || !req.file || !password || req.file.truncated) {
      return res.status(400).json({ status: false, error: "Name, email, phone, location, and a valid image file are required fields" });
    }

    const image = req.file.path;

    // Assuming you pass the required fields to register an owner
    const successRes = await OwnerService.registerOwner({ name, email, phone, location: { latitude, longitude }, image, password });

    // Log success response
    console.log(successRes.status);

    // Send success response
    res.json({ status: true, success: "Owner registered successfully" });
  } catch (err) {
    // Log error and pass it to the error handler middleware
    console.error('Error occurred during owner registration:', err);
    next(err);
  }
};


exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    
    // Check for missing fields
    if (!email || !password) {
      return res.status(400).json({ status: 'error', message: 'Name and password are required fields' });
    }

    const loginResult = await OwnerService.loginOwner({ email, password });

    // Check the result and send appropriate response
    if (loginResult.status === 'success') {
      // Log success response
      console.log(loginResult.message);

      // Send success response
      res.json({ status: 'success', message: 'Login successful' });
    } else {
      // Log error and send error response
      console.error(loginResult.message);
      res.status(401).json({ status: 'error', message: 'Invalid credentials' });
    }
  } catch (err) {
    // Log error and pass it to the error handler middleware
    console.error('Error occurred during login:', err);
    next(err);
  }
};


// Assuming you have a database model named Owner and a database connection

// const Owner = require('../models/owner.model'); // Import your Owner model
function splitStr(str, separator) {
  // Function to split string
  let string = str.split(separator);
  console.log(string);
}
exports.getOwnerDetails = async (req, res) => {
  try {
    const userEmail = req.query.email;
    const owner = await OwnerModel.findOne({ email: userEmail });
    
    if (owner) {
      let temp = owner.image.slice(owner.image.lastIndexOf('/') + 1);
      console.log(temp);
      res.status(200).json({
        name: owner.name,
        location: owner.location,
        phone: owner.phone,
        imageUrl : owner.image,
      });
    } else {
      res.status(404).json({ message: 'Owner not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
};