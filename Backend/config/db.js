// const mongoose = require('mongoose');
// // mongodb://localhost:27017/
// const connection = mongoose.createConnection('mongodb://127.0.0.1:27017/ParkEasy')
//     .on('open', () => {
//         console.log('Mongoose connection established');
//     })
//     .on('error', (error) => {
//         console.log('Mongoose connection error:', error);
//     });
    
// module.exports = connection;

const mongoose = require('mongoose');
const connection = mongoose.createConnection('mongodb+srv://pankajrathod2040:pankajrathod@cluster0.ekad3gy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');

connection.on('open', () => {
    console.log('Mongoose connection established');
});

connection.on('error', (error) => {
    console.error('Mongoose connection error:', error);
});

// Export the connection object for use in other parts of your application
module.exports = connection;

