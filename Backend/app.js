const express = require("express");
const bodyParser = require("body-parser")
const userRouter = require("./routers/user.router");
const ownerRouter = require("./routers/owner.router");
const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public')); // Make sure to serve static files if needed
app.use(express.json());
// app.use('/user',userRouter);
app.use('/',ownerRouter);
app.use('/',userRouter);
app.use('/',ownerRouter);
module.exports = app;
