const UserModel = require('../model/user.model');
const VehicleModel = require('../model/vehicle.model');
const bcrypt = require('bcrypt');
class UserService {
    static async registerUser(email,password,phone,name) {
        try {
            const createUser = new UserModel({ email, password, phone,name});
            return createUser.save();
        } catch (e) {
            throw e;
        }
    }
    static async login({email, password}){
        try {
            // Find the owner in the database based on name and password
            const owner = await UserModel.findOne({ email });
            
            if (owner) {
              console.log(owner);
              // Compare the provided password with the hashed password in the database
              const passwordMatch = await bcrypt.compare(password, owner.password);
              if (passwordMatch) {
                // Successful login
                return { status: 'success', message: 'Login successful' };
              } else {
                // Password doesn't match
                return { status: 'error', message: 'Invalid credentials' };
              }
            } else {
              // Owner not found
              return { status: 'error', message: 'Invalid credentials' };
            }
          } catch (error) {
            // Handle any errors
            console.error('Error during login:', error);
            throw error; // You may want to handle this differently based on your use case
          }
    }
    static async addUserVehicle({userEmail, vehicleData}) {
      try {
          const user = await UserModel.findOne({ email: userEmail });
          if (!user) {
              throw new Error('User not found');
            }
            console.log(vehicleData);
          // console.log(typeof vehicleData);
          const parsedVehicleData = JSON.parse(vehicleData);

        // Ensure that all required fields for the Vehicle model are provided in parsedVehicleData
        const { brand, model, seating, numberPlate } = parsedVehicleData;
          // console.log("here why undefined" , brand)
          if (!numberPlate || !seating || !model || !brand) {
              throw new Error('Missing required fields for the Vehicle model');
          }

          const newVehicle = new VehicleModel({
              numberPlate,
              seating,
              model,
              brand,
          });

          await newVehicle.save();

          user.vehicles.push(newVehicle);
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
      console.log(user.vehicles);
      return user.vehicles;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = UserService;
