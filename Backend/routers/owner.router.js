// const router = require('express').Router();
// const upload = require('Middelware/uploadMiddleware');

// // router.post('/register', OwnerController.register);

// // module.exports = router;

// // const upload = require('register'); // Specify the correct path

// router.post('/register', upload.single('image'), OwnerController.register);
// 222222222222222222222222222
// const express = require('express');
// const router = express.Router();
// const upload = require('../uploadMiddleware'); // Adjust the path accordingly

// router.post('/upload', upload.single('image'), OwnerController.register);

// module.exports = router;


// owner.router.js



// uisng folder upload
const router = require('express').Router();
const multer = require('multer');
const OwnerController = require('../controller/owner.controller');


const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  },
});

const upload = multer({ storage: storage });

router.post('/register', upload.single('image'), OwnerController.register);

module.exports = router;



// const express = require('express');
// const router = express.Router();
// const OwnerController = require('../controller/owner.controller');

// router.post('/register', OwnerController.register);

// module.exports = router;
