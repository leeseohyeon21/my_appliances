import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:my_appliances/data/user_model.dart';
import 'package:my_appliances/repo/user_service.dart';
import 'package:my_appliances/utils/logger.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier() {
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _setNewUser(user);
      logger.d('현재 유저상태: $user');
      notifyListeners();
    });
  }

  Future _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber != null) {
        String phoneNumber = user.phoneNumber!;
        String userKey = user.uid;

        UserModel userModel = UserModel(
            userKey: "",
            phoneNumber: phoneNumber,
            createdDate: DateTime.now().toUtc());

        await UserService().createNewUser(userModel.toJson(), userKey);
        _userModel = await UserService().getUserModel(userKey);
        logger.d(_userModel!.toJson().toString());
    }
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
}