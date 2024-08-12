const express = require('express');
const router = express.Router();
const bookingController = require('../controller/bookingdetails.controller');


// Route to add parking
router.post('/bookparking', bookingController.addParking);

module.exports = router;
