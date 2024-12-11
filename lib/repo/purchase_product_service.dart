import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_appliances/constants/data_keys.dart';
import 'package:my_appliances/data/purchase_product_model.dart';

class PurchaseProductService{
  static final PurchaseProductService _purchaseProductService = PurchaseProductService._internal();
  factory PurchaseProductService() => _purchaseProductService;
  PurchaseProductService._internal();

  Future createNewProduct(
      PurchaseProductModel purchaseProductModel, String productKey, String userKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USER_PURCHASE_PRODUCTS).doc(productKey);
    DocumentReference<Map<String, dynamic>> userProductDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_PURCHASE_PRODUCTS)
        .doc(productKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if(!documentSnapshot.exists){
      await FirebaseFirestore.instance.runTransaction((transaction) async{
        transaction.set(documentReference, purchaseProductModel.toJson());
        transaction.set(userProductDocReference, purchaseProductModel.toMinJson());
      });
    }
  }

  Future<PurchaseProductModel> getItem(String productKey) async{
    if(productKey[0] == ':'){
      productKey = productKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USER_PURCHASE_PRODUCTS).doc(productKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    PurchaseProductModel purchaseProductModel = PurchaseProductModel.fromSnapshot(documentSnapshot);
    return purchaseProductModel;
  }

  Future<List<PurchaseProductModel>> getItems() async{
    //콜렉션 접근
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_USER_PURCHASE_PRODUCTS);
    //콜렉션 받기
    QuerySnapshot<Map<String, dynamic>> snapshots =
    await collectionReference.get();
    //받아온 데이터 아이템 모델로 저장
    List<PurchaseProductModel> products = [];
    for(int i = 0; i<snapshots.size; i++){
      PurchaseProductModel purchaseProductModel = PurchaseProductModel.fromQuerySnapshot(snapshots.docs[i]);
      products.add(purchaseProductModel);
    }
    return products;
  }

  Future<List<PurchaseProductModel>> getUserItems(String userKey,
      {String? productKey}) async{
    //콜렉션 접근
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_PURCHASE_PRODUCTS);
    //콜렉션 받기
    QuerySnapshot<Map<String, dynamic>> snapshots =
    await collectionReference.get();
    //받아온 데이터 아이템 모델로 저장
    List<PurchaseProductModel> products = [];
    for(int i = 0; i<snapshots.size; i++){
      PurchaseProductModel purchaseProductModel = PurchaseProductModel.fromQuerySnapshot(snapshots.docs[i]);
      if(!(productKey != null && productKey == purchaseProductModel.productKey))
        products.add(purchaseProductModel);
    }
    return products;
  }

}