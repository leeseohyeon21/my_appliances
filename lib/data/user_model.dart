import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
  !: null값 없음
  ?: null값일 수 있음
  late: null값은 없는 대신 데이터가 늦게 들어올 수 있음
*/

class UserModel{

  late String userKey; //유저 고유키값
  late String phoneNumber;
  late DateTime createdDate;
  DocumentReference? reference;  //Document 고유키값

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.createdDate,
    this.reference,});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
    phoneNumber = json['phoneNumber'];
    createdDate = json['createdDate'] == null? DateTime.now().toUtc() : (json['createdDate'] as Timestamp).toDate();
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['createdDate'] = createdDate;
    return map;
  }
}