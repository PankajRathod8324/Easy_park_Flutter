const UserModel = require('../model/user.model');
const UserService = require('../services/user.services');
const Bookingdetail = require('../model/bookingdetails.model');
const path = require('path');
const VehicleModel = require('../model/vehicle.model');
const ParkArea = require('../model/parkarea.model');
exports.register = async (req, res, next) => {
  try {
    const { email, password, phone, name } = req.body;
    const profile = path.basename(req.file.path);
    const successRes = await UserService.registerUser(email, password, phone, name, profile);

    res.json({ status: true, success: "success login" })
  } catch (err) {
    throw err;
  }
}

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    console.log(req.body);
    if (!email || !password) {
      return res.status(400).json({ status: 'error', message: 'Name and password are required fields' });
    }

    const loginResult = await UserService.login({ email, password });
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
}
exports.addVehicleToUser = async (req, res) => {
  const { userEmail, vehicleData } = req.body;
  // const  = req.body; // Assuming your frontend sends JSON data
  console.log(userEmail);
  try {
    const newVehicle = await UserService.addUserVehicle({ userEmail, vehicleData });
    res.status(200).json(newVehicle);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getusers = async (req, res) => {
  const email = req.query.email;
  console.log(req.query.email);
  try {
    // Find the user based on the provided email
    const user = await UserModel.findOne({ email: email });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Return the user details
    res.status(200).json({
      name: user.name,
      email: user.email,
      vehicles: user.vehicles,
      phone: user.phone,
      profile: user.profile
      // Add other user details as needed
    });
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getAllVehiclesByEmail = async (req, res, next) => {
  const userEmail = req.query.userEmail;
  try {
    const vehicles = await UserService.getAllVehiclesByEmail(userEmail);
    res.status(200).json({ vehicles });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}



exports.checkAvailability = async (req, res) => {
  try {
    const { parkAreaId, startTime, endTime } = req.query;
    console.log(parkAreaId);
    // Find all booking details for the specified park area
    const bookingdetails = await Bookingdetail.find({ parkArea: parkAreaId });
    console.log(startTime);
    console.log(endTime);
    // console.log("booked");
    // Initialize array to store booked slots
    let bookedSlots = [];
    // console.log(bookingdetails);
    // Check if the requested time slot is available
    for (const booking of bookingdetails) {
      const bookingStartTime = new Date(booking.startTime);
      const bookingEndTime = new Date(booking.endTime);
      const requestStartTime = new Date(startTime);
      const requestEndTime = new Date(endTime);
      console.log(bookingStartTime)
      console.log(bookingEndTime)

      console.log(requestStartTime);
      console.log(requestEndTime);

      console.log(bookingStartTime == requestStartTime);
      if (
        (requestStartTime >= bookingStartTime && requestStartTime < bookingEndTime) ||
        (requestEndTime > bookingStartTime && requestEndTime <= bookingEndTime) ||
        (requestStartTime <= bookingStartTime && requestEndTime >= bookingEndTime)
      ) {
        bookedSlots.push(booking.slot);
      }
    }
    console.log(bookedSlots);
    // If slot is available, send success response along with booked slots
    res.status(200).json({ message: 'Slot available', bookedSlots });
  } catch (error) {
    console.error('Error checking availability:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.getUserBookingDetails = async (req, res) => {
  try {
    const userEmail = req.query.email;
    console.log(req.params);
    const userDetails = await UserService.getUserDetailsByEmail(userEmail);
    console.log(userDetails);
    const vehicles = userDetails.vehicles;
    const vehicleDetails = await UserService.getVehicleDetails(vehicles);
    const bookingDetails = await UserService.getBookingDetails(vehicleDetails);
    const parkAreaIds = bookingDetails.map(booking => booking.parkArea);
    const ownerIds = await UserService.getParkAreaOwnerIds(parkAreaIds);
    const parkAreaDetails = await UserService.getParkAreaDetails(parkAreaIds);
    const dataToSendToFrontend = {
      userDetails,
      vehicleDetails,
      bookingDetails,
      ownerIds,
      parkAreaDetails
    };
    console.log(dataToSendToFrontend);
    res.json(dataToSendToFrontend);
  } catch (error) {
    console.error('Error retrieving user booking details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.cancelBooking = async (req, res) => {
  const bookingId = req.query.id;

  try {
    // Find the booking details
    const booking = await Bookingdetail.findById(bookingId);
    if (!booking) {
      return res.status(404).json({ message: "Booking not found" });
    }

    // Update booking status to 'Cancelled'
    booking.status = 'Cancelled';
    await booking.save();

    // Find the vehicle associated with the booking
    const vehicle = await VehicleModel.findById(booking.vehicle);
    if (!vehicle) {
      return res.status(404).json({ message: "Vehicle not found" });
    }

    // Remove booking from vehicle's current bookings and move to old bookings
    vehicle.bookingdetails = null; // or vehicle.bookingdetails = ''; depending on your schema
    await vehicle.save();
    vehicle.oldbookingdetails.push(bookingId);
    await vehicle.save();

    // Find the park area associated with the booking
    const parkArea = await ParkArea.findById(booking.parkArea);
    if (!parkArea) {
      return res.status(404).json({ message: "Park Area not found" });
    }

    // Remove booking from park area's current bookings and move to old bookings
    parkArea.bookingdetails.pull(bookingId);
    parkArea.oldbookingdetails.push(bookingId);
    await parkArea.save();

    // Send success response
    res.status(200).json({ message: "Booking cancelled successfully" });
  } catch (error) {
    console.error("Error cancelling booking:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.removeExpiredBookings = async (req,res) => {
  try {
    const currentTime = new Date();

    // Find all booking details where the end time is less than the current time
    const expiredBookings = await Bookingdetail.find({ endTime: { $lt: currentTime } });

    // Remove expired bookings and update status
    for (const booking of expiredBookings) {
      booking.status = 'Completed';
      await booking.save();
      // Remove the booking slot from the park area
      await ParkArea.findByIdAndUpdate(booking.parkArea, { $pull: { boocked_slots: booking.slot }, $push: { oldbookingdetails: booking._id } });

      // Update booking status to 'Completed'


      // Update vehicle to move booking from bookingdetails to oldbookingdetails
      await VehicleModel.findByIdAndUpdate(booking.vehicle, { $set: { bookingdetails: null }, $push: { oldbookingdetails: booking._id } });
    }

    console.log('Expired bookings removed successfully');
    res.status(200).json({ message: "Remove Success Fully" });
  } catch (error) {
    console.error('Error removing expired bookings:', error);
    return 500; 
  }
};
