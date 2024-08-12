final url = 'http://192.168.0.104:3000/';

// Endpoints for owner registration and login
final registrationOwner = url + "registerOwner";
final loginOwner = url + 'login';

// Endpoints for user registration and login
final registrationUser = url + "registerUser";
final loginUser = url + 'loginUser';

// Endpoint for fetching user details
final getUser = url + 'getUser';

// Endpoints for vehicle management
final addVehicle = url + 'addVehicle';
final getVehicle = url + 'getvehicles';

final bookparking = url + 'bookparking';
// Endpoint for finding parking areas near the user
final parkNearMe = url + 'parkNearMe';
final getParkAreaDetails = url + 'parkareas/';

final getParkArea = url + 'getParkArea';
final updateParkArea =
    url + 'updateParkArea'; // Endpoint for fetching park area details by ID
// final bookparking = url + 'bookparking';
final getParkAreabyemil = url + 'parkAreasbyemail';

// Endpoints for owner-specific actions
final getOwnerdetails = url + 'getownerdetails';
final addParkArea = url + 'addParkArea';

//Review
final addreview = url + 'addreview';
final getreview = url + 'getreview';
//Check Avilabe Slots
final getunAvailableSlots = url + 'checkAvailability';

final getOwnerBookingDetails = url + 'getOwnerBookingDetails';
final getUserBookingDetails = url + 'getUserBookings';
final cancleBooking = url + 'cancleBooking';

final removeOldBookings = url + 'removeOldBookings';
