// const UserModel = require('../model/user.model');

// class UserService{
//     static async registerUser(email, password){
//         try{
//             const createUser=new UserModel({email, password});
//             return createUser.save();
//         }catch(e){
//             throw e;
//         }
//     }
// }

// module.exports = UserService;.

const UserModel = require('../model/user.model');

class UserService {
    static async registerUserWithNameAndImage(name, image) {
        try {
            const createUser = new UserModel({ name, image });
            return createUser.save();
        } catch (e) {
            throw e;
        }
    }
}

module.exports = UserService;
