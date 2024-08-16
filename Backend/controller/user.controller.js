const UserModel = require('../model/user.model');
const UserService = require('../services/user.services');
const Bookingdetail = require('../model/bookingdetails.model');
const path = require('path');
const VehicleModel = require('../model/vehicle.model');
const ParkArea = require('../model/parkarea.model');

exports.register = async (req, res, next) => {
  try {
    const { email, password, phone, name } = req.body;
    const profile = req.file ? path.basename(req.file.path) : null; // Handle file upload safely
    const successRes = await UserService.registerUser(email, password, phone, name, profile);
    res.json({ status: true, success: "Successfully registered" });
  } catch (err) {
    console.error("Error during registration:", err);
    next(err);
  }
}

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ status: 'error', message: 'Email and password are required fields' });
    }

    const loginResult = await UserService.login({ email, password });
    if (loginResult.status === 'success') {
      res.json({ status: 'success', message: 'Login successful' });
    } else {
      res.status(401).json({ status: 'error', message: 'Invalid credentials' });
    }
  } catch (err) {
    console.error('Error occurred during login:', err);
    next(err);
  }
}

exports.addVehicleToUser = async (req, res) => {
  const { userEmail, vehicleData } = req.body;
  try {
    const newVehicle = await UserService.addUserVehicle({ userEmail, vehicleData });
    res.status(200).json(newVehicle);
  } catch (error) {
    console.error('Error adding vehicle:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getusers = async (req, res) => {
  const email = req.query.email;
  try {
    const user = await UserModel.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      name: user.name,
      email: user.email,
      vehicles: user.vehicles,
      phone: user.phone,
      profile: user.profile
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
    console.error('Error fetching vehicles:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

exports.checkAvailability = async (req, res) => {
  try {
    const { parkAreaId, startTime, endTime } = req.query;
    const bookingdetails = await Bookingdetail.find({ parkArea: parkAreaId });

    let bookedSlots = [];
    const requestStartTime = new Date(startTime);
    const requestEndTime = new Date(endTime);

    for (const booking of bookingdetails) {
      const bookingStartTime = new Date(booking.startTime);
      const bookingEndTime = new Date(booking.endTime);

      if (
        (requestStartTime >= bookingStartTime && requestStartTime < bookingEndTime) ||
        (requestEndTime > bookingStartTime && requestEndTime <= bookingEndTime) ||
        (requestStartTime <= bookingStartTime && requestEndTime >= bookingEndTime)
      ) {
        bookedSlots.push(booking.slot);
      }
    }

    res.status(200).json({ message: 'Slot available', bookedSlots });
  } catch (error) {
    console.error('Error checking availability:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.getUserBookingDetails = async (req, res) => {
  try {
    const userEmail = req.query.email;
    const userDetails = await UserService.getUserDetailsByEmail(userEmail);
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

    res.json(dataToSendToFrontend);
  } catch (error) {
    console.error('Error retrieving user booking details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.cancelBooking = async (req, res) => {
  const bookingId = req.query.id;

  try {
    const booking = await Bookingdetail.findById(bookingId);
    if (!booking) {
      return res.status(404).json({ message: "Booking not found" });
    }

    booking.status = 'Cancelled';
    await booking.save();

    const vehicle = await VehicleModel.findById(booking.vehicle);
    if (!vehicle) {
      return res.status(404).json({ message: "Vehicle not found" });
    }

    vehicle.bookingdetails = null;
    vehicle.oldbookingdetails.push(bookingId);
    await vehicle.save();

    const parkArea = await ParkArea.findById(booking.parkArea);
    if (!parkArea) {
      return res.status(404).json({ message: "Park Area not found" });
    }

    parkArea.bookingdetails.pull(bookingId);
    parkArea.oldbookingdetails.push(bookingId);
    await parkArea.save();

    res.status(200).json({ message: "Booking cancelled successfully" });
  } catch (error) {
    console.error("Error cancelling booking:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.removeExpiredBookings = async (req, res) => {
  try {
    const currentTime = new Date();

    const expiredBookings = await Bookingdetail.find({ endTime: { $lt: currentTime } });

    for (const booking of expiredBookings) {
      booking.status = 'Completed';
      await booking.save();

      await ParkArea.findByIdAndUpdate(booking.parkArea, {
        $pull: { boocked_slots: booking.slot },
        $push: { oldbookingdetails: booking._id }
      });

      await VehicleModel.findByIdAndUpdate(booking.vehicle, {
        $set: { bookingdetails: null },
        $push: { oldbookingdetails: booking._id }
      });
    }

    res.status(200).json({ message: "Expired bookings removed successfully" });
  } catch (error) {
    console.error('Error removing expired bookings:', error);
    res.status(500).json({ message: "Internal server error" });
  }
};
