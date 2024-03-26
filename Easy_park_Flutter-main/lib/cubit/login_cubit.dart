import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_park_app/common/globs.dart';
import 'package:easy_park_app/common/service_call.dart';
import 'package:equatable/equatable.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  void submitLogin( String mobileCode, String mobile, String userType ) {
    try {

      emit(LoginHUDState());
      ServiceCall.post({
        "user_type": userType,
        "mobile_code": mobileCode,
        "mobile": mobile,
        "os_type": Platform.isIOS ? "i" : Platform.isAndroid ? "a" : "w",
        "push_token":"",
        "socket_id":"", 
      }, SVKey.svLogin, withSuccess: (responseObj) async {

        if( ( responseObj[KKey.status]  as String? ?? "" ) == "1" ) {
            ServiceCall.userObj = responseObj[KKey.payload] as Map? ?? {};
            ServiceCall.userType = ServiceCall.userObj["user_type"] as int? ?? 1;


            Globs.udSet(ServiceCall.userObj, Globs.userPayload);
            Globs.udBoolSet(true, Globs.userLogin);
            emit(LoginApiResultState());
            emit(LoginInitialState());
        }else{
          emit(LoginErrorState(responseObj[KKey.message] ?? MSG.fail ),);
        }
        
      }, failure: (err) async {
          emit(LoginErrorState(err));
      }, );
      
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
