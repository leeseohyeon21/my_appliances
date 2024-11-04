import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class SelectImageNotifier extends ChangeNotifier{
  List<Uint8List> _images = [];

  Future setNewImages(List<XFile>? newImages) async {
    if(newImages != null && newImages.isNotEmpty){
      _images.clear();
      newImages.forEach((xfile) async{
        _images.add(await xfile.readAsBytes());
      });
      notifyListeners();
    }
  }
  void removeImage(int index){
    if(_images.length >= index){  //이미지의 개수가 삭제한 인덱스번호보다 크거나 같다면
      _images.removeAt(index);    //해당 인덱스 번호의 이미지를 삭제시켜라.
    }
    notifyListeners();
  }

  List<Uint8List> get images => _images;
}