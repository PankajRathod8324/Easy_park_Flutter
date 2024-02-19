// const OwnerService = require('../services/owner.services');

// exports.register = async (req, res, next) => {
//     try {
//         const { name, email, password, phone, location, image } = req.body;

//         // Assuming you pass the required fields to register an owner
//         const successRes = await OwnerService.registerOwner({ name, email, password, phone, location, image });

//         res.json({ status: true, success: "Owner registered successfully" });
//     } catch (err) {
//         next(err); // Pass the error to the error handler middleware
//     }
// };
// 22222222222222222222222222
// const multer = require('multer');
// const storage = multer.memoryStorage(); // Store image in memory for now
// const upload = multer({ storage: storage });

// exports.register = async (req, res, next) => {
//     try {
//         const { name, email, password, phone, location } = req.body;

//         // Assuming you pass the required fields to register an owner
//         const image = req.file ? req.file.buffer : undefined; // Use req.file.buffer for image data

//         const successRes = await OwnerService.registerOwner({ name, email, password, phone, location, image });

//         res.json({ status: true, success: "Owner registered successfully" });
//     } catch (err) {
//         next(err); // Pass the error to the error handler middleware
//     }
// };
// owner.controller.js


//using store in 
const OwnerService = require('../services/owner.services');

exports.register = async (req, res, next) => {
  // print(req.body.name);
  try {
    const { name } = req.body;
    // console.log(req.file.path);
    // Assuming you pass the required fields to register an owner
    image = req.file.path;
    const successRes = await OwnerService.registerOwner({ name, image });
    console.log(successRes.status);
    res.json({ status: true, success: "Owner registered successfully" });
  } catch (err) {
    console.log(err);
    next(err); // Pass the error to the error handler middleware
  }
};
//uisng direct 
// const OwnerService = require('../services/owner.services');

// exports.register = async (req, res, next) => {
//   try {
//     const { name } = req.body;
//     console.log(req.body);
//     // Check for missing fields
//     if (!name || !req.file || req.file.truncated) {
//       return res.status(400).json({ status: false, error: "Name and valid image file are required fields" });
//     }

//     const image = req.file.path;

//     // Assuming you pass the required fields to register an owner
//     const successRes = await OwnerService.registerOwner({ name, image });

//     // Log success response
//     console.log(successRes.status);

//     // Send success response
//     res.json({ status: true, success: "Owner registered successfully" });
//   } catch (err) {
//     // Log error and pass it to the error handler middleware
//     console.error('Error occurred during owner registration:', err);
//     next(err);
//   }
// };
