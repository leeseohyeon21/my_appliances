import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_appliances/constants/data_keys.dart';

class ItemModel{
  late String itemKey;
  late String userKey;
  late List<String> imageDownloadUrls;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late String detail;
  late DateTime createdDate;
  late DocumentReference? reference;

  ItemModel({
    required this.itemKey,
    required this.userKey,
    required this.imageDownloadUrls,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.createdDate,
    this.reference});

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    userKey = json[DOC_USERKEY]??"";  //??"": null값이면 ""
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    title = json[DOC_TITLE]??"";
    category = json[DOC_CATEGORY]??"none";
    price = json[DOC_PRICE]??0;
    negotiable = json[DOC_NEGOTIABLE]??false;
    detail = json[DOC_DETAIL]??"";
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  ItemModel.fromAlgoliaObject(Map<String, dynamic> json, this.itemKey){
    userKey = json[DOC_USERKEY]??"";
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
      ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
      : [];
    title = json[DOC_TITLE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? "";
    createdDate = DateTime.now().toUtc();
  }

  ItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_TITLE] = title;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DETAIL] = detail;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson(){
    var map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_TITLE] = title;
    map[DOC_PRICE] = price;
    return map;
  }

  //아이템키 생성
  static String generateItemKey(String uid){
    String timeInMilli = DateTime.now().microsecondsSinceEpoch.toString();
    return '${uid}_$timeInMilli';
  }
}