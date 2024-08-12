const express = require('express');
const router = express.Router();
const ReviewController = require('../controller/reviewdetails.controller');


// Route to add parking
router.post('/addreview', ReviewController.addReview);
router.get('/getreview' , ReviewController.getreview);
module.exports = router;
