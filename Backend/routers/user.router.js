const router = require('express').Router();
const UserController  =  require('../controller/user.controller');

// const x = require("../controller/user.controller");

console.log("Controler")
router.post('/register',UserController.register );

module.exports = router;