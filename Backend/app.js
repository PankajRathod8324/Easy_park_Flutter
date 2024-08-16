const express = require("express");
const bodyParser = require("body-parser");
const userRouter = require("./routers/user.router");
const ownerRouter = require("./routers/owner.router");
const bookingdetailsRouter = require("./routers/bookingdetails.router");
const reviewRouter = require("./routers/reviewdetails.router");
const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public')); // Serve static files if needed
app.use(express.json());

// Define routes
app.use('/', ownerRouter);
app.use('/', userRouter);
app.use('/', bookingdetailsRouter);
app.use('/', reviewRouter);

module.exports = app;
