const UserModel = require('../model/user.model');
const VehicleModel = require('../model/vehicle.model');
const BookingDetails = require('../model/bookingdetails.model');
const ParkArea = require('../model/parkarea.model');
const bcrypt = require('bcrypt');

class UserService {
  static async registerUser(email, password, phone, name, profile) {
    try {
      const createUser = new UserModel({ email, password, phone, name, profile });
      return createUser.save();
    } catch (e) {
      throw e;
    }
  }

  static async login({ email, password }) {
    try {
      const user = await UserModel.findOne({ email });

      if (user) {
        // Compare the provided password with the hashed password in the database
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (passwordMatch) {
          // Successful login
          return { status: 'success', message: 'Login successful' };
        } else {
          // Password doesn't match
          return { status: 'error', message: 'Invalid credentials' };
        }
      } else {
        // User not found
        return { status: 'error', message: 'Invalid credentials' };
      }
    } catch (error) {
      console.error('Error during login:', error);
      throw error;
    }
  }

  static async addUserVehicle(userEmail, vehicleData) {
    try {
      const user = await UserModel.findOne({ email: userEmail });
      if (!user) {
        throw new Error('User not found');
      }

      const { brand, model, seating, numberPlate } = vehicleData;

      if (!brand || !model || !seating || !numberPlate) {
        throw new Error('Missing required fields for the Vehicle model');
      }

      const newVehicle = new VehicleModel({
        numberPlate,
        seating,
        model,
        brand,
        user: user._id, // Assigns the user
      });

      await newVehicle.save();

      user.vehicles.push(newVehicle._id);
      await user.save();

      return newVehicle;
    } catch (error) {
      throw error;
    }
  }

  static async getAllVehiclesByEmail(userEmail) {
    try {
      const user = await UserModel.findOne({ email: userEmail }).populate('vehicles');
      if (!user) {
        throw new Error('User not found');
      }
      return user.vehicles;
    } catch (error) {
      throw error;
    }
  }

  static async getUserDetailsByEmail(email) {
    try {
      return await UserModel.findOne({ email }).populate('vehicles');
    } catch (error) {
      throw error;
    }
  }

  static async getVehicleDetails(vehicleIds) {
    try {
      return await VehicleModel.find({ _id: { $in: vehicleIds } });
    } catch (error) {
      throw error;
    }
  }

  static async getBookingDetails(vehicleDetails) {
    try {
      const vehicleIds = vehicleDetails.map(vehicle => vehicle._id);
      return await BookingDetails.find({ vehicle: { $in: vehicleIds } });
    } catch (error) {
      throw error;
    }
  }

  static async getParkAreaOwnerIds(parkAreaIds) {
    try {
      const parkAreas = await ParkArea.find({ _id: { $in: parkAreaIds } });
      return parkAreas.map(parkArea => parkArea.owner);
    } catch (error) {
      throw error;
    }
  }

  static async getParkAreaDetails(parkAreaId) {
    try {
      return await ParkArea.find({ _id: { $in: parkAreaId } });
    } catch (error) {
      throw error;
    }
  }
}

module.exports = UserService;
