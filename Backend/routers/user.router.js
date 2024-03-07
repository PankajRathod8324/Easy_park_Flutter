const router = require('express').Router();
const UserController  =  require('../controller/user.controller');

// const x = require("../controller/user.controller");

router.post('/registerUser',UserController.register );
router.post('/loginUser',UserController.login );
router.post('/addVehicle', UserController.addVehicleToUser);
router.get('/getUser', UserController.getusers);
router.get('/getvehicles', UserController.getAllVehiclesByEmail);

module.exports = router;