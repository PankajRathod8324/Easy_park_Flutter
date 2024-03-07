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

const upload = multer({ storage: storage });

router.post('/registerOwner', upload.single('image'), OwnerController.register);
router.post('/login',OwnerController.login);
router.get('/getownerdetails', OwnerController.getOwnerDetails);
// router.get('/getCoordinates', OwnerController.getCoordinates);
module.exports = router;




