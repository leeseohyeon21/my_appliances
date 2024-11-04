import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:my_appliances/data/user_model.dart';
import 'package:my_appliances/repo/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_appliances/utils/logger.dart';

//ChangeNotifier: UI데이터가 변경되면 변경값을 자동으로 업데이터해주는.
class UserProvider extends ChangeNotifier{

  UserProvider(){
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser(){
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _setNewUser(user);
      logger.d('현재 유저상태 : $user');
      notifyListeners();  //상태가 변했다고 전파하는 알림종
    });
  }

  Future _setNewUser(User? user) async {

    _user = user;

    if (user != null && user.phoneNumber != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;

      UserModel userModel = UserModel(
        userKey: "",
        phoneNumber: phoneNumber,
        createdDate: DateTime.now().toUtc()
      );

      await UserService().createNewUser(userModel.toJson(), userKey);

      _userModel = await UserService().getUserModel(userKey);
      logger.d(_userModel!.toJson().toString());
    }
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;

}