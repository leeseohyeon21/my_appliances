import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_appliances/utils/logger.dart';

class ImageStorage{
  static Future<List<String>> uploadImages(
      List<Uint8List>images, String itemKey) async{
    //이미지저장 DB타입
    var metaData = SettableMetadata(contentType: 'image/jpeg');
    //다운로드 링크 리스트
    List<String> downloadUrls = [];
    //이미지 저장 경로지정
    for(int i = 0; i<images.length; i++){
      Reference ref = FirebaseStorage.instance.ref().child('images/$itemKey/$i.jpg');

      try {
        if (images[i].isNotEmpty) {
          logger.d('Uploading image $i to path: images/$itemKey/$i.jpg');
          //이미지 업로드
          await ref.putData(images[i], metaData);
          //성공시 다운로드 URL 추가
          String downloadUrl = await ref.getDownloadURL();
          logger.d('File uploaded successfully: $downloadUrl');
          downloadUrls.add(downloadUrl);
          }
        }catch(error){
        logger.e("Error uploading image $i: $error");
        if (error is FirebaseException) {
          logger.e("Firebase Error: ${error.message}");
        }
      }
    }

    return downloadUrls;
  }
}