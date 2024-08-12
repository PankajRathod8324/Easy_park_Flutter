const express = require("express");
const bodyParser = require("body-parser")
const userRouter = require("./routers/user.router");
const ownerRouter = require("./routers/owner.router");
<<<<<<< HEAD
const BookingRouter =  require("./routers/bookingdetails.router");
const ReviewRouter = require( "./routers/reviewdetails.router" );
const app = express();

const bookingdetailsRouter = require("./routers/bookingdetails.router");
=======
const app = express();

>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public')); // Make sure to serve static files if needed
app.use(express.json());
// app.use('/user',userRouter);
app.use('/',ownerRouter);
app.use('/',userRouter);
app.use('/',ownerRouter);
<<<<<<< HEAD
app.use('/',bookingdetailsRouter);
app.use('/',BookingRouter)
app.use('/', ReviewRouter)
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
module.exports = app;
