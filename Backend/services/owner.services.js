const OwnerModel = require('../model/owner.model');
const bcrypt = require('bcrypt');
class OwnerService {
  static async registerOwner({ name, email, phone, location, image, password }) {
    try {
      // Assuming location is an object with latitude and longitude properties
      const { latitude, longitude } = location;

      const createOwner = new OwnerModel({
        name,
        email,
        phone,
        location: { latitude, longitude }, // Save location as an object
        image,
        password,
      });

      return createOwner.save();
    } catch (e) {
      console.error(e);
      throw e;
    }
  }
  static async loginOwner({ email, password }) {
    try {
      // Find the owner in the database based on name and password
      const owner = await OwnerModel.findOne({ email });

      if (owner) {
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
  // static async getOwnerDetailsByEmail(email) {
  //   try {
  //     const owner = await OwnerModel.findOne({ email });
  //     return owner;
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}

module.exports = OwnerService;
