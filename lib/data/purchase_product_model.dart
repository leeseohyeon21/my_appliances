import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_appliances/constants/data_keys.dart';

class PurchaseProductModel{
  late String productKey;
  late String userKey;
  late List<String> imageDownloadUrls;
  late String modelName;
  late String productName;
  late String brand;
  late DateTime purchaseDate;
  late num price;
  late num ASPeriod;
  late String memo;
  late DateTime createdDate;
  late DocumentReference? reference;

  PurchaseProductModel({
    required this.productKey,
    required this.userKey,
    required this.imageDownloadUrls,
    required this.modelName,
    required this.productName,
    required this.brand,
    required this.purchaseDate,
    required this.price,
    required this.ASPeriod,
    required this.memo,
    required this.createdDate,
    this.reference});

  PurchaseProductModel.fromJson(Map<String, dynamic> json, this.productKey, this.reference) {
    userKey = json[DOC_USERKEY]??"";  //??"": null값이면 ""
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    modelName = json[DOC_MODELNAME]??"";
    productName = json[DOC_PRODUCTNAME]??"";
    brand = json[DOC_BRAND]??"";
    purchaseDate = json[DOC_PURCHASEDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    price = json[DOC_PRICE]??0;
    ASPeriod = json[DOC_ASPERIOD]??0;
    memo = json[DOC_MEMO]??"";
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  PurchaseProductModel.fromAlgoliaObject(Map<String, dynamic> json, this.productKey){
    userKey = json[DOC_USERKEY]??"";
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    modelName = json[DOC_MODELNAME] ?? "";
    productName = json[DOC_PRODUCTNAME]??"none";
    brand = json[DOC_BRAND]??"";
    purchaseDate = json[DOC_PURCHASEDATE]??0;
    price = json[DOC_PRICE]??0;
    ASPeriod = json[DOC_ASPERIOD]??0;
    memo = json[DOC_MEMO]??"";
    createdDate = DateTime.now().toUtc();
  }

  PurchaseProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  PurchaseProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_MODELNAME] = modelName;
    map[DOC_PRODUCTNAME] = productName;
    map[DOC_BRAND] = brand;
    map[DOC_PURCHASEDATE] = purchaseDate;
    map[DOC_PRICE] = price;
    map[DOC_ASPERIOD] = ASPeriod;
    map[DOC_MEMO] = memo;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson(){
    var map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_PRODUCTNAME] = productName;
    map[DOC_PRICE] = price;
    return map;
  }

  //아이템키 생성
  static String generateProductKey(String uid){
    String timeInMilli = DateTime.now().microsecondsSinceEpoch.toString();
    return '${uid}_$timeInMilli';
  }
}