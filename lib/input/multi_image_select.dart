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
        var imgSize = _size.width/3;
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

                    if(images != null && images.isNotEmpty){
                      await context.read<SelectImageNotifier>().setNewImages(images);
                      _isPickingImages = false;
                      setState(() {

                      });
                    }
                  },
                  child: Container(
                    width: imgSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2
                      ),
                    ),
                    child: _isPickingImages?Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircularProgressIndicator()
                    ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.grey),
                        Text('0/10',
                        style: Theme.of(context).textTheme.titleSmall,)
                      ],
                    ),
                  ),
                ),
              ),
              ...List.generate(selectImageNotifier.images.length, (index) =>
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: common_sm_padding,
                          bottom: common_sm_padding,
                          right: common_sm_padding
                        ),
                        child: ExtendedImage.memory(
                          selectImageNotifier.images[index],
                          fit: BoxFit.cover,
                          height: imgSize,
                          width: imgSize,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                          loadStateChanged: (state){

                            switch(state.extendedImageLoadState){

                              case LoadState.loading:
                                return Container(
                                  padding: EdgeInsets.all(imgSize/5),
                                    height: imgSize,
                                    width: imgSize,
                                    child: CircularProgressIndicator()
                              );

                              case LoadState.completed:
                                return null;

                              case LoadState.failed:
                                return Icon(Icons.cancel);
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: (){
                            selectImageNotifier.removeImage(index);
                            setState(() {

                            });
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            size: 30,
                            color: Colors.red[300]
                          ),
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