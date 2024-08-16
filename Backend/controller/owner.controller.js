const OwnerModel = require('../model/owner.model');
const OwnerService = require('../services/owner.services');
const ParkArea = require('../model/parkarea.model');
const BookingDetails = require('../model/bookingdetails.model');
const VehicleModel = require('../model/vehicle.model');
const path = require('path');

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

    const image = path.basename(req.file.path);

    // Assuming you pass the required fields to register an owner
    const successRes = await OwnerService.registerOwner({
      name,
      email,
      phone,
      location: { latitude, longitude },
      image,
      password
    });

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
      return res.status(400).json({ status: 'error', message: 'Email and password are required fields' });
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

exports.getOwnerDetails = async (req, res) => {
  try {
    const ownerEmail = req.query.email;
    const owner = await OwnerModel.findOne({ email: ownerEmail });
    
    if (owner) {
      const imageFileName = owner.image.slice(owner.image.lastIndexOf('/') + 1);
      console.log(imageFileName);
      res.status(200).json({
        name: owner.name,
        location: owner.location,
        phone: owner.phone,
        imageUrl: owner.image,
        parkAreas: owner.parkingAreas,
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
    const { ownerEmail, latitude, longitude } = req.body;
    const location = { latitude, longitude };
    const { name, pincode, phone, address, timing, price_per_hr, slots } = req.body;
    const images = req.files ? req.files.map(file => file.filename) : [];

    const parkAreaData = {
      name,
      location,
      pincode,
      images,
      phone,
      slots,
      address,
      timing,
      price_per_hr,
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
    const { latitude, longitude, postalCode } = req.query;

    // Fetch all park areas for the given owner
    const parkAreas = await OwnerService.getAllParkAreas(latitude, longitude, postalCode);

    // Extract latitude and longitude from each park area
    const markers = parkAreas.map((parkArea) => ({
      latitude: parkArea.location.latitude,
      longitude: parkArea.location.longitude,
      id: parkArea._id,
    }));

    res.status(200).json({ parkAreas, markers });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getParkAreaDetails = async (req, res) => {
  try {
    const parkAreaId = req.params.id;
    const parkAreaDetails = await OwnerService.getParkAreaDetailsById(parkAreaId);
    res.status(200).json(parkAreaDetails);
  } catch (error) {
    console.error('Error fetching park area details:', error);
    res.status(500).json({ error: 'Failed to fetch park area details' });
  }
};

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
    updatedParkArea.images = updatedImages;
    
    const savedParkArea = await updatedParkArea.save();
    res.status(200).json({ success: true, data: savedParkArea });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.getParkAreaById = async (req, res) => {
  const parkAreaId = req.query.id;

  try {
    const parkArea = await ParkArea.findById(parkAreaId);

    if (!parkArea) {
      return res.status(404).json({ success: false, message: 'Park area not found' });
    }
    res.status(200).json({ success: true, data: parkArea });
  } catch (error) {
    console.error('Error fetching park area:', error);
    res.status(500).json({ success: false, error: error.message });
  }
};

// Controller function to get park areas by owner's email
exports.getParkAreasByOwnerEmail = async (req, res) => {
  try {
    const email = req.query.email;
    const owner = await OwnerModel.findOne({ email }).populate('parkingAreas');

    if (!owner) {
      return res.status(404).json({ message: 'Owner not found' });
    }

    const parkAreas = owner.parkingAreas.map(area => ({
      address: area.address,
      timing: area.timing,
      imageUrl: area.images.length > 0 ? area.images[0] : '',
      phone: area.phone,
      price_per_hr: area.price_per_hr,
      slots: area.slots,
      id: area._id,
    }));

    return res.status(200).json(parkAreas);
  } catch (error) {
    console.error('Error fetching park areas by owner email:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};

exports.getOwnerBookingDetails = async (req, res) => {
  try {
    const ownerEmail = req.query.email;
    const ownerDetails = await OwnerModel.findOne({ email: ownerEmail }).populate('parkingAreas');
    
    const parkAreaIds = ownerDetails.parkingAreas.map(parkArea => parkArea._id);
    const bookingDetails = await BookingDetails.find({ parkArea: { $in: parkAreaIds } });
    
    const vehicleIds = bookingDetails.map(booking => booking.vehicle);
    const vehicleDetails = await VehicleModel.find({ _id: { $in: vehicleIds } });

    const dataToSendToFrontend = {
      ownerDetails,
      bookingDetails,
      vehicleDetails,
    };

    res.json(dataToSendToFrontend);
  } catch (error) {
    console.error('Error retrieving owner booking details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
