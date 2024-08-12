const OwnerModel = require('../model/owner.model');
const OwnerService = require('../services/owner.services');
<<<<<<< HEAD
const ParkArea = require('../model/parkarea.model');
const BookingDetails = require('../model/bookingdetails.model');
const VehicleModel = require('../model/vehicle.model');

const path = require('path');

=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766

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

<<<<<<< HEAD
    const image = path.basename(req.file.path);
=======
    const image = req.file.path;
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766

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

<<<<<<< HEAD
    console.log(email);
    const loginResult = await OwnerService.loginOwner({ email, password });
    
=======
    const loginResult = await OwnerService.loginOwner({ email, password });

>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
    const ownerEmail = req.query.email;
    const owner = await OwnerModel.findOne({ email: ownerEmail });
=======
    const userEmail = req.query.email;
    const owner = await OwnerModel.findOne({ email: userEmail });
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
    
    if (owner) {
      let temp = owner.image.slice(owner.image.lastIndexOf('/') + 1);
      console.log(temp);
      res.status(200).json({
        name: owner.name,
        location: owner.location,
        phone: owner.phone,
        imageUrl : owner.image,
<<<<<<< HEAD
        parkAreas : owner.parkingAreas,
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
    console.log('------------------------');
    console.log(req.body);
    const location = {"latitude" : latitude , "longitude" : longitude } ;
    // slots = 1;
    const { name, pincode, phone, address, timing ,price_per_hr , slots} = req.body; 
    const images = req.files ? req.files.map(file => file.filename) : [];
   
    const parkAreaData = {
      name,
=======
    console.log(req.body);
    const location = {"latitude" : latitude , "longitude" : longitude } ;
    slots = 1;
    const { pincode, phone, address, timing } = req.body; 
    const images = req.files ? req.files.map(file => file.filename) : [];
   
    const parkAreaData = {
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
      location,
      pincode,
      images,
      phone,
      slots,
      address,
      timing,
<<<<<<< HEAD
      price_per_hr,
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
    // console.log(req.query);
    const {latitude , longitude , postalCode} = req.query;// Assuming you pass the owner's email as a query parameter
    // console.log(postalCode);
=======
    console.log(req.query);
    const {latitude , longitude , postalCode} = req.query;// Assuming you pass the owner's email as a query parameter
    console.log(postalCode);
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
    // Fetch all park areas for the given owner
    const parkAreas = await OwnerService.getAllParkAreas(latitude,longitude,postalCode);

    // Extract latitude and longitude from each park area
    const markers = parkAreas.map((parkArea) => {
      return {
        latitude: parkArea.location.latitude,
        longitude: parkArea.location.longitude,
<<<<<<< HEAD
        id: parkArea._id,
      };
    });
    console.log('Park Areas :::::');
    console.log(parkAreas);
    console.log(markers);
=======
      };
    });

>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
    res.status(200).json({ parkAreas, markers });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

<<<<<<< HEAD
// exports.getParkAreas = async (req, res) => {
//   try {
//     const { latitude, longitude, pincode } = req.query; // Assuming latitude, longitude, and pincode are passed as query parameters

//     // Call the service function to get park areas
//     const parkAreas = await OwnerService.getParkAreas(latitude, longitude, pincode);

//     // Send the response with the retrieved park areas
//     res.json({ parkAreas });
//   } catch (error) {
//     console.error('Error getting park areas:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// };

exports.getParkAreaDetails = async (req, res) => {
  try {
    const parkAreaId = req.params.id;
    // print(req.body);
    console.log(req.body);
    const parkAreaDetails = await OwnerService.getParkAreaDetailsById(parkAreaId);
    res.status(200).json(parkAreaDetails);
  } catch (error) {
    console.error('Error fetching park area details:', error);
    res.status(500).json({ error: 'Failed to fetch park area details' });
  }
};

// exports.getHalfParkDeatils = async (req, res) => {
//   try {
//     const ownerEmail = req.query.email;
//     const owner = await OwnerModel.findOne({ email: ownerEmail });
=======
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
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
exports.updateParkArea = async (req, res) => {
  const id = req.query.id;
  const updateFields = req.body;
  const images_new = req.files ? req.files.map(file => file.filename) : [];
  const images = JSON.parse(req.body.images);
  try {
    // Find the ParkArea by its ID
    const updatedParkArea = await ParkArea.findByIdAndUpdate(id, updateFields, {
      new: true,
      runValidators: true,
    });

    if (!updatedParkArea) {
      return res.status(404).json({ success: false, message: 'ParkArea not found' });
    }

    // Concatenate existing images with newly uploaded images
    const updatedImages = [...images, ...images_new];
    console.log(updatedImages);
    // Update the ParkArea with new images
    updatedParkArea.images = updatedImages;
    
    const savedParkArea = await updatedParkArea.save();
    console.log(savedParkArea);
    res.status(200).json({ success: true, data: savedParkArea });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, error: error.message });
  }
};



exports.getParkAreaById = async (req, res) => {
  const parkAreaId = req.query.id;
  // console.log(parkAreaId);
  try {
    const parkArea = await ParkArea.findById(parkAreaId);

    if (!parkArea) {
      return res.status(404).json({ success: false, message: 'Park area not found' });
    }
    // console.log(parkArea);
    res.status(200).json({ success: true, data: parkArea });
  } catch (error) {
    console.error('Error fetching park area:', error);
    res.status(500).json({ success: false, error: error.message });
  }
};

// Controller function to get park areas by owner's email
exports.getParkAreasByOwnerEmail = async (req, res) => {
    try {
        const  email  = req.query.email;
        const owner = await OwnerModel.findOne({ email }).populate('parkingAreas');
        if (!owner) {
            return res.status(404).json({ message: 'Owner not found' });
        }
        console.log(owner);
        // Extract park area details from the owner
        const parkAreas = owner.parkingAreas.map(area => ({
            address: area.address,
            timing: area.timing,
            imageUrl: area.images.length > 0 ? area.images[0] : '',
            phone:area.phone,
            price_per_hr: area.price_per_hr,
            slots: area.slots,
            id: area._id,
        }));
        return res.status(200).json(parkAreas);
    } catch (error) {
        console.error('Error fetching park areas by owner email:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};


exports.getOwnerBookingDetails = async (req, res) => {
  try {
    const ownerEmail = req.query.email; // Assuming owner's email is passed as a query parameter
    console.log(ownerEmail);
    const ownerDetails = await OwnerModel.findOne({ email: ownerEmail }).populate('parkingAreas');
    
    const parkAreaIds = ownerDetails.parkingAreas.map(parkArea => parkArea._id);
    const parkAreaDetails = await ParkArea.find({ _id: { $in: parkAreaIds } });

    const bookingDetails = await BookingDetails.find({ parkArea: { $in: parkAreaIds } });
    
    const vehicleIds = bookingDetails.map(booking => booking.vehicle);
    const vehicleDetails = await VehicleModel.find({ _id: { $in: vehicleIds } });

    const dataToSendToFrontend = {
      ownerDetails,
      // parkAreaDetails,
      bookingDetails,
      vehicleDetails
    };

    res.json(dataToSendToFrontend);
  } catch (error) {
    console.error('Error retrieving owner booking details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
=======



>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
