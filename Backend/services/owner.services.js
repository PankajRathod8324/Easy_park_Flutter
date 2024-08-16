const mongoose = require('mongoose');
const OwnerModel = require('../model/owner.model');
const bcrypt = require('bcrypt');
const parkAreaModel = require('../model/parkarea.model');

class OwnerService {
  static calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    const dLat = this.deg2rad(lat2 - lat1);
    const dLon = this.deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
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
      const owner = await OwnerModel.findOne({ email });

      if (owner) {
        const passwordMatch = await bcrypt.compare(password, owner.password);

        if (passwordMatch) {
          return { status: 'success', message: 'Login successful' };
        } else {
          return { status: 'error', message: 'Invalid credentials' };
        }
      } else {
        return { status: 'error', message: 'Invalid credentials' };
      }
    } catch (error) {
      console.error('Error during login:', error);
      throw error;
    }
  }

  static async addParkArea(ownerEmail, parkAreaData) {
    try {
      const owner = await OwnerModel.findOne({ email: ownerEmail });

      if (!owner) {
        throw new Error('Owner not found');
      }

      parkAreaData.owner = owner._id;

      const parkArea = new parkAreaModel(parkAreaData);
      await parkArea.save();

      owner.parkingAreas.push(parkArea._id);
      await owner.save();

      return parkArea;
    } catch (error) {
      throw error;
    }
  }

  static async getAllParkAreas(latitude, longitude, pincode) {
    try {
      const parkAreas = await parkAreaModel.find({ pincode }).populate('owner');

      const filteredParkAreas = parkAreas
        .map((parkArea) => {
          const distance = this.calculateDistance(latitude, longitude, parkArea.location.latitude, parkArea.location.longitude);

          if (distance <= 2700) {
            return {
              location: parkArea.location,
              name: parkArea.name,
              pincode: parkArea.pincode,
              images: parkArea.images,
              phone: parkArea.phone,
              slots: parkArea.slots,
              address: parkArea.address,
              timing: parkArea.timing,
              id: parkArea._id,
              price_per_hr: parkArea.price_per_hr,
              owner: parkArea.owner,
              booked_slots: parkArea.booked_slots,
              latitude: parkArea.location.latitude,
              longitude: parkArea.location.longitude,
              reviewdetails: parkArea.reviewdetails,
            };
          }

          return null;
        })
        .filter(Boolean);

      return filteredParkAreas;
    } catch (error) {
      throw error;
    }
  }

  static async getParkAreaDetailsById(parkAreaId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(parkAreaId)) {
        throw new Error('Invalid park area ID');
      }

      const parkArea = await parkAreaModel.findById(parkAreaId).populate('owner');
      if (!parkArea) {
        throw new Error('Park area not found');
      }

      return {
        location: parkArea.location,
        name: parkArea.name,
        pincode: parkArea.pincode,
        images: parkArea.images,
        phone: parkArea.phone,
        slots: parkArea.slots,
        address: parkArea.address,
        timing: parkArea.timing,
        price_per_hr: parkArea.price_per_hr,
        owner: parkArea.owner,
        latitude: parkArea.location.latitude,
        longitude: parkArea.location.longitude,
      };
    } catch (error) {
      throw error;
    }
  }
}

module.exports = OwnerService;
