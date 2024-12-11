import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_appliances/constants/data_keys.dart';
import 'package:my_appliances/data/lental_product_model.dart';

class LentalProductService{
  static final LentalProductService _lentalProductService = LentalProductService._internal();
  factory LentalProductService() => _lentalProductService;
  LentalProductService._internal();

  Future createNewProduct(
      LentalProductModel lentalProductModel, String productKey, String userKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USER_RENTAL_PRODUCTS).doc(productKey);
    DocumentReference<Map<String, dynamic>> userProductDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_RENTAL_PRODUCTS)
        .doc(productKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if(!documentSnapshot.exists){
      await FirebaseFirestore.instance.runTransaction((transaction) async{
        transaction.set(documentReference, lentalProductModel.toJson());
        transaction.set(userProductDocReference, lentalProductModel.toMinJson());
      });
    }
  }

  Future<LentalProductModel> getItem(String productKey) async{
    if(productKey[0] == ':'){
      productKey = productKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USER_RENTAL_PRODUCTS).doc(productKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    LentalProductModel lentalProductModel = LentalProductModel.fromSnapshot(documentSnapshot);
    return lentalProductModel;
  }

  Future<List<LentalProductModel>> getItems() async{
    //콜렉션 접근
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_USER_RENTAL_PRODUCTS);
    //콜렉션 받기
    QuerySnapshot<Map<String, dynamic>> snapshots =
    await collectionReference.get();
    //받아온 데이터 아이템 모델로 저장
    List<LentalProductModel> products = [];
    for(int i = 0; i<snapshots.size; i++){
      LentalProductModel lentalProductModel = LentalProductModel.fromQuerySnapshot(snapshots.docs[i]);
      products.add(lentalProductModel);
    }
    return products;
  }

  Future<List<LentalProductModel>> getUserItems(String userKey,
      {String? productKey}) async{
    //콜렉션 접근
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_RENTAL_PRODUCTS);
    //콜렉션 받기
    QuerySnapshot<Map<String, dynamic>> snapshots =
    await collectionReference.get();
    //받아온 데이터 아이템 모델로 저장
    List<LentalProductModel> products = [];
    for(int i = 0; i<snapshots.size; i++){
      LentalProductModel lentalProductModel = LentalProductModel.fromQuerySnapshot(snapshots.docs[i]);
      if(!(productKey != null && productKey == lentalProductModel.productKey))
        products.add(lentalProductModel);
    }
    return products;
  }

}