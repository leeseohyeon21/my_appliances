import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_appliances/constants/data_keys.dart';

class LentalProductModel{
  late String productKey;
  late String userKey;
  late List<String> imageDownloadUrls;
  late String modelName;
  late String productName;
  late String brand;
  late DateTime lentalDate;
  late DateTime terminalDate;
  late num dutyPeriod;
  late String management;
  late num firstPrice;
  late num monthPrice;
  late String memo;
  late DateTime createdDate;
  late DocumentReference? reference;

  LentalProductModel({
    required this.productKey,
    required this.userKey,
    required this.imageDownloadUrls,
    required this.modelName,
    required this.productName,
    required this.brand,
    required this.lentalDate,
    required this.terminalDate,
    required this.dutyPeriod,
    required this.management,
    required this.firstPrice,
    required this.monthPrice,
    required this.memo,
    required this.createdDate,
    this.reference});

  LentalProductModel.fromJson(Map<String, dynamic> json, this.productKey, this.reference) {
    userKey = json[DOC_USERKEY]??"";  //??"": null값이면 ""
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    modelName = json[DOC_MODELNAME]??"";
    productName = json[DOC_PRODUCTNAME]??"";
    brand = json[DOC_BRAND]??"";
    lentalDate = json[DOC_LENTALDATE] == null
    ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    terminalDate = json[DOC_TERMINALDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    dutyPeriod = json[DOC_DUTYPERIOD]??0;
    management = json[DOC_MANAGEMENT]??"";
    firstPrice = json[DOC_FIRSTPRICE]??0;
    monthPrice = json[DOC_MONTHPRICE]??0;
    memo = json[DOC_MEMO]??"";
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  LentalProductModel.fromAlgoliaObject(Map<String, dynamic> json, this.productKey){
    userKey = json[DOC_USERKEY]??"";
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    modelName = json[DOC_MODELNAME]??"";
    productName = json[DOC_PRODUCTNAME]??"";
    brand = json[DOC_BRAND]??"";
    lentalDate = json[DOC_LENTALDATE]??0;
    terminalDate = json[DOC_TERMINALDATE]??0;
    dutyPeriod = json[DOC_DUTYPERIOD]??0;
    management = json[DOC_MANAGEMENT]??"";
    firstPrice = json[DOC_FIRSTPRICE]??0;
    monthPrice = json[DOC_MONTHPRICE]??0;
    memo = json[DOC_MEMO]??"";
    createdDate = DateTime.now().toUtc();
  }

  LentalProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  LentalProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_MODELNAME] = modelName;
    map[DOC_PRODUCTNAME] = productName;
    map[DOC_BRAND] = brand;
    map[DOC_LENTALDATE] = lentalDate;
    map[DOC_TERMINALDATE] = terminalDate;
    map[DOC_DUTYPERIOD] = dutyPeriod;
    map[DOC_MANAGEMENT]= management;
    map[DOC_FIRSTPRICE] = firstPrice;
    map[DOC_MONTHPRICE] = monthPrice;
    map[DOC_MEMO] = memo;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson(){
    var map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_MODELNAME] = modelName;
    map[DOC_MONTHPRICE] = monthPrice;
    return map;
  }

  //아이템키 생성
  static String generateProductKey(String uid){
    String timeInMilli = DateTime.now().microsecondsSinceEpoch.toString();
    return '${uid}_$timeInMilli';
  }
}