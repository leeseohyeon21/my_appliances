import 'package:flutter/widgets.dart';

//ChangeNotifier: UI데이터가 변경되면 변경값을 자동으로 업데이터해주는.
class UserProvider extends ChangeNotifier{
  //유저 로그인 여부 프라이빗 변수 선언
  bool _userLoggedIn = false;

  //프라이빗 변수값 접근 및 변경함수
  void SetUserAuth(bool authState){
    _userLoggedIn = authState;
    notifyListeners();
  }

  //변경함수에 연결된 외부변수 선언
  bool get userState => _userLoggedIn;
}