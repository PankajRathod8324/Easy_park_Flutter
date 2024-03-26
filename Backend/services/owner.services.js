const OwnerModel = require('../model/owner.model');
const bcrypt = require('bcrypt');
const parkAreaModel = require('../model/parkarea.model');
class OwnerService {

   static calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c; // Distance in kilometers

    return distance * 1000; // Convert distance to meters
  }

  // Helper function to convert degrees to radians
  static deg2rad(deg) {
    return deg * (Math.PI / 180);
  }
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
  static async addParkArea(ownerEmail, parkAreaData) {
    try {
      // Find the owner based on the provided email
      const owner = await OwnerModel.findOne({ email: ownerEmail });
  
      if (!owner) {
        throw new Error('Owner not found');
      }
  
      // Add owner's _id to parkAreaData
      parkAreaData.owner = owner._id;
  
      // Create a new park area
      const parkArea = new parkAreaModel(parkAreaData);
      await parkArea.save();
  
      // Associate the park area with the owner
      owner.parkingAreas.push(parkArea._id);
      await owner.save();
  
      return parkArea;
    } catch (error) {
      throw error;
    }
  }
  

  static async getAllParkAreas(latitude, longitude, pincode) {
    try {
      // Find park areas in the database based on the provided pincode
      const parkAreas = await parkAreaModel.find({ pincode }).populate('owner');
      console.log(parkAreas);
      // Filter park areas based on geographical coordinates
      const filteredParkAreas = parkAreas.map((parkArea) => {
        // Calculate the distance between the provided coordinates and the park area coordinates
        // const distance = calculateDistanee(latitude, longitude, parkArea.location.latitude, parkArea.location.longitude);
        const distance = 200;
        // Include the park area in the result only if it's within a certain distance (e.g., 700 meters)
        if (distance <= 700) {
          return {
            location: parkArea.location,
            pincode: parkArea.pincode,
            images: parkArea.images,
            phone: parkArea.phone,
            slots: parkArea.slots,
            address: parkArea.address,
            timing: parkArea.timing,
            // Add other fields as needed
            owner: parkArea.owner, // Include owner information
  
            // Include latitude and longitude
            latitude: parkArea.location.latitude,
            longitude: parkArea.location.longitude,
          };
        }
  
        return null; // Exclude the park area from the result if it's too far away
      }).filter(Boolean); // Remove null values from the result array
  
      return filteredParkAreas;
    } catch (error) {
      throw error;
    }
  }
  
  
  
  // Helper function to calculate the distance between two sets of coordinates
  calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c; // Distance in kilometers
  
    return distance * 1000; // Convert distance to meters
  }
  
  // Helper function to convert degrees to radians
  deg2rad(deg) {
    return deg * (Math.PI / 180);
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

