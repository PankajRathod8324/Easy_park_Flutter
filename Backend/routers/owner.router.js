// uisng folder upload
const router = require('express').Router();
const multer = require('multer');
const OwnerController = require('../controller/owner.controller');


const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, '../Easy_park_Flutter-main/assets/images/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  },
});

const storageParkArea = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, '../Easy_park_Flutter-main/assets/images/owners_parking');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  },
});

const upload = multer({ storage: storage });
const uploadParkArea = multer({ storage : storageParkArea });

router.post('/registerOwner', upload.single('image'), OwnerController.register);
router.post('/login',OwnerController.login);
router.get('/getownerdetails', OwnerController.getOwnerDetails);
router.post('/addParkArea', uploadParkArea.array('images', 3), OwnerController.addParkArea);

router.get('/parkNearMe',OwnerController.getAllParkArea);
router.get('/parkareas/:id', OwnerController.getParkAreaDetails);
router.put('/updateParkArea', uploadParkArea.array('images', 3),OwnerController.updateParkArea);
router.get('/getParkArea', OwnerController.getParkAreaById);
router.get('/parkAreasbyemail', OwnerController.getParkAreasByOwnerEmail);
router.get('/getOwnerBookingDetails' , OwnerController.getOwnerBookingDetails);
module.exports = router;




