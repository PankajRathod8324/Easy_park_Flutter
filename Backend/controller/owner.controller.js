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


exports.addParkArea = async (req, res) => {
  try {
    const {ownerEmail , latitude , longitude } = req.body;
    console.log(req.body);
    const location = {"latitude" : latitude , "longitude" : longitude } ;
    slots = 1;
    const { pincode, phone, address, timing } = req.body; 
    const images = req.files ? req.files.map(file => file.filename) : [];
   
    const parkAreaData = {
      location,
      pincode,
      images,
      phone,
      slots,
      address,
      timing,
      // Add other fields as needed
    };

    const newParkArea = await OwnerService.addParkArea(ownerEmail, parkAreaData);
    res.status(201).json(newParkArea);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }

};

exports.getAllParkArea = async (req, res) => {
  try {
    console.log(req.query);
    const {latitude , longitude , postalCode} = req.query;// Assuming you pass the owner's email as a query parameter
    console.log(postalCode);
    // Fetch all park areas for the given owner
    const parkAreas = await OwnerService.getAllParkAreas(latitude,longitude,postalCode);

    // Extract latitude and longitude from each park area
    const markers = parkAreas.map((parkArea) => {
      return {
        latitude: parkArea.location.latitude,
        longitude: parkArea.location.longitude,
      };
    });

    res.status(200).json({ parkAreas, markers });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getParkAreas = async (req, res) => {
  try {
    const { latitude, longitude, pincode } = req.query; // Assuming latitude, longitude, and pincode are passed as query parameters

    // Call the service function to get park areas
    const parkAreas = await OwnerService.getParkAreas(latitude, longitude, pincode);

    // Send the response with the retrieved park areas
    res.json({ parkAreas });
  } catch (error) {
    console.error('Error getting park areas:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
// exports.getHalfParkDeatils = async (req, res) => {
//   try {
//     const userEmail = req.query.email;
//     const owner = await OwnerModel.findOne({ email: userEmail });
//     const parkAreas = await OwnerService.getAllParkAreas(latitude,longitude,postalCode);
//     console.log(req.query);
//     const {name , address} = req.query;// Assuming you pass the owner's email as a query parameter
//     console.log(name);
//     if (owner) {
//       // let temp = owner.image.slice(owner.image.lastIndexOf('/') + 1);
//       console.log(temp);
//       res.status(200).json({
//         name: owner.name,
//         address: parkAreas,address,
//         // imageUrl : owner.image,
//       });
//     } else {
//       res.status(404).json({ message: 'Owner not found' });
//     }
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Internal server error' });
//   }
// };



