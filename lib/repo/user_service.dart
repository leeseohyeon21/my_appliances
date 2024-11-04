import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_appliances/constants/data_keys.dart';
import 'package:my_appliances/data/user_model.dart';
import 'package:my_appliances/utils/logger.dart';

class UserService{

  //싱글턴 패턴 실행(단일 인스턴스 전역 활용)
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  //json 데이터와 유저키를 받아와서 신규유저 저장함수
  Future createNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);

    //기존 가입자 식별을 위해 DB참조
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    //db에 기존 회원이 존재하지 않으면 저장
    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
  }

  //파이어스토어에서 유저정보 불러오기(캐시저장용)
  Future<UserModel> getUserModel(String userKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentReference.get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }
}