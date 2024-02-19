
// class OwnerService {
//     static async registerOwner({ name, email, password, phone, location, image }) {
//         try {
//             const createOwner = new OwnerModel({ name, email, password, phone, location, image });
//             return createOwner.save();
//         } catch (e) {
//             throw e;
//         }
//     }
// }

// module.exports = OwnerService;
//22222222222222222222
// const OwnerModel = require('../model/owner.model');

// class OwnerService {
//     static async registerOwner({ name, email, password, phone, location, image }) {
//         try {
//             const createOwner = new OwnerModel({ name, email, password, phone, location, image });
//             return createOwner.save();
//         } catch (e) {
//             throw e;
//         }
//     }
// }

// module.exports = OwnerService;

// owner.service.js

const OwnerModel = require('../model/owner.model');


// using folder store image
class OwnerService {
  static async registerOwner({ name, image }) {
    try {
      const createOwner = new OwnerModel({ name, image });
      console.log(image);
      return createOwner.save();
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
}

module.exports = OwnerService;
 

//using direct
// const OwnerModel = require('../model/owner.model');

// class OwnerService {
//   static async registerOwner({ name, imageBuffer }) {
//     const newOwner = new OwnerModel({ name, image: imageBuffer });
//     return await newOwner.save();
//   }
// }

// module.exports = OwnerService;
