const bookingService = require('../services/bookingdetails.services');

// Controller function to add parking
// const bookingService = require('../services/bookingService');

// exports.addParking = async (req, res) => {
//     try {
//         console.log(req.body);
//         // const existingBooking = await bookingService.checkExistingBooking(req.body);
//         // if (existingBooking) {
//         //     return res.status(400).json({ error: 'User already has a booking for the same vehicle within the specified time period' });
//         // }

//         const parking = await bookingService.addBooking(req.body);
//         res.status(201).json(parking);
//     } catch (error) {
//         console.error("Error Adding Parking:", error);
//         res.status(500).json({ error: 'Internal Server Error' });
//     }
// };

exports.addParking = async (req, res) => {
    try {
        console.log(req.body);
        // console.log("Request Body:", req.body); // Log the request body
        const parking = await bookingService.addBooking(req.body);
        // console.log("Saved Parking Details:", parking); // Lx
        res.status(201).json(parking);
    } catch (error) {
        console.error("Error Adding Parking:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

