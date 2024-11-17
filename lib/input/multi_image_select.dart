import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:provider/provider.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({super.key});

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  bool _isPickingImages = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SelectImageNotifier selectImageNotifier = context.watch<SelectImageNotifier>();
        Size _size = MediaQuery
            .of(context)
            .size;
        var imgSize = (_size.width/3) - common_bg_padding*2;
        var imgCorner = 16.0;
        return SizedBox(
          height: _size.width/3,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal, //다수 이미지 우측으로 스크롤 가능
            children: [
              Padding(
                padding: const EdgeInsets.all(common_sm_padding),
                child: InkWell(
                  onTap: () async {
                    _isPickingImages = true;
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 10);
                    if(images != null && images.isNotEmpty) {
                      await context.read<SelectImageNotifier>().setNewImages(
                          images);
                    }
                    _isPickingImages = false;
                    setState(() {});
                  },
                  child: Container(
                    child: _isPickingImages
                        ?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator()
                    ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.grey),
                        Text('0/10',
                          style: Theme.of(context).textTheme.titleSmall,)
                      ],
                    ),
                    width: imgSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(imgCorner),
                      border: Border.all(
                          color: Colors.grey,
                          width: 1),),
                  ),
                ),
              ),
              ...List.generate(selectImageNotifier.images.length, (index) =>
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: common_bg_padding,
                          top: common_bg_padding,
                          bottom: common_bg_padding,
                        ),
                        child: ExtendedImage.memory(
                          selectImageNotifier.images[index],
                          width: imgSize,
                          height: imgSize,
                          fit: BoxFit.cover,
                          loadStateChanged: (state){
                            switch(state.extendedImageLoadState){
                              case LoadState.loading:
                                return Container(
                                    width: imgSize,
                                    height: imgSize,
                                  padding: EdgeInsets.all(imgSize/3),
                                    child: CircularProgressIndicator()
                              );
                              case LoadState.completed:
                                return null;
                              case LoadState.failed:
                                return Icon(Icons.cancel);
                            }
                          },
                          borderRadius: BorderRadius.circular(imgCorner),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.all(8),
                          onPressed: (){
                            selectImageNotifier.removeImage(index);
                          },
                          icon: Icon(
                            Icons.remove_circle,
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ]
                  ),
            ),
          ],),
        );
      },
    );
  }
}