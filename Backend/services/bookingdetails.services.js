const VehicleModel = require('../model/vehicle.model');
const ParkAreaModel = require('../model/parkarea.model');
const BookingdetailsModel = require('../model/bookingdetails.model');
// const BookingDetails = require('../model/bookingdetails.model');


exports.addBooking = async (bookingData) => {
    try {
        console.log("Booking Data:", bookingData); 

        // Create a new booking details document
        const newBooking = new BookingdetailsModel(bookingData.bookingdetails);
        newBooking.slot = bookingData.parkingSlot;
        // Save the booking details
        const savedBooking = await newBooking.save();
        console.log("Saved Booking:", savedBooking); 

        // Update the vehicle's bookingdetails field with the new booking details
        await VehicleModel.updateOne({ _id: bookingData.bookingdetails.vehicle }, { bookingdetails: savedBooking._id });

        // Update the park area's bookingdetails array with the new booking details
        await ParkAreaModel.updateOne({ _id: bookingData.bookingdetails.parkArea }, { $addToSet: { bookingdetails: savedBooking._id } });
        console.log(bookingData.parkingSlot);
        // Update the booked slots in the ParkArea model
        await ParkAreaModel.updateOne(
            { _id: bookingData.bookingdetails.parkArea },
            { $addToSet: { boocked_slots: bookingData.parkingSlot } } // Add the booked slot to the array
        );
        
        return savedBooking;
    } catch (error) {
        console.error("Error Adding Booking:", error); 
        throw error;
    }
};

// exports.checkExistingBooking = async (bookingData) => {
//     try {
//         const { vehicle, startTime, endTime } = bookingData;

//         // Query to check if there is any existing booking for the same vehicle within the specified time period
//         const existingBooking = await BookingdetailsModel.findOne({
//             vehicle: vehicle,
//             startTime: { $lt: endTime }, // Check if the existing booking end time is after the new booking start time
//             endTime: { $gt: startTime } // Check if the existing booking start time is before the new booking end time
//         });

//         return existingBooking;
//     } catch (error) {
//         throw error;
//     }
// };