const router = require('express').Router();
const UserController  =  require('../controller/user.controller');
const multer = require('multer');

// const x = require("../controller/user.controller");
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, '../Easy_park_Flutter-main/assets/images/user');
    },
    filename: function (req, file, cb) {
      cb(null, Date.now() + '-' + file.originalname);
    },
  });

const upload = multer({ storage: storage });

router.post('/registerUser', upload.single('image'), UserController.register);

router.post('/registerUser',UserController.register );
router.post('/loginUser',UserController.login );
router.post('/addVehicle', UserController.addVehicleToUser);
router.get('/getUser', UserController.getusers);
router.get('/getvehicles', UserController.getAllVehiclesByEmail);
router.get('/checkAvailability', UserController.checkAvailability);
router.get('/getUserBookings' , UserController.getUserBookingDetails);
router.get('/cancleBooking' , UserController.cancelBooking);
router.get('/removeOldBookings' ,  UserController.removeExpiredBookings)

module.exports = router;
