// uploadMiddleware.js

const multer = require('multer');
const path = require('path');

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'upload/'); // Specify the directory where you want to store the uploaded files
  },
  filename: function (req, file, cb) {
    // Use the current timestamp as a unique filename
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

// Create a multer instance with the specified storage configuration
const upload = multer({ storage: storage });

module.exports = upload;
