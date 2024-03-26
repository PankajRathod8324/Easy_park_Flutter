const UserModel = require('../model/user.model');
const UserService = require('../services/user.services');

exports.register = async (req, res, next) => {
  try {
    const { email, password, phone ,name} = req.body;

    const successRes = await UserService.registerUser(email, password, phone,name);

    res.json({ status: true, success: "success login" })
  } catch (err) {
    throw err;
  }
}

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    console.log(req.body);
    if (!email || !password) {
      return res.status(400).json({ status: 'error', message: 'Name and password are required fields' });
    }

    const loginResult = await UserService.login({ email, password });
    if (loginResult.status === 'success') {
      // Log success response
      console.log(loginResult.message);

      // Send success response
      res.json({ status: 'success', message: 'Login successful' });
    } else {
      // Log error and send error response
      console.error(loginResult.message);
      res.status(401).json({ status: 'error', message: 'Invalid credentials' });
    }
  } catch (err) {
    // Log error and pass it to the error handler middleware
    console.error('Error occurred during login:', err);
    next(err);
  }
}
exports.addVehicleToUser = async (req, res) => {
  const { userEmail,vehicleData } = req.body;
  // const  = req.body; // Assuming your frontend sends JSON data
  console.log(userEmail);
  try {
    const newVehicle = await UserService.addUserVehicle({userEmail, vehicleData});
    res.status(200).json(newVehicle);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getusers = async (req, res) => {
  const { userEmail } = req.query;

  try {
    // Find the user based on the provided email
    const user = await UserModel.findOne({ email: userEmail });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Return the user details
    res.status(200).json({
      name: user.name,
      // Add other user details as needed
    });
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

exports.getAllVehiclesByEmail =  async(req, res, next)=> {
  const userEmail = req.query.userEmail;
  try {
    const vehicles = await UserService.getAllVehiclesByEmail(userEmail);
    res.status(200).json({ vehicles });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
