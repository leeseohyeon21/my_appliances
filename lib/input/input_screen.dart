import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/data/item_model.dart';
import 'package:my_appliances/input/multi_image_select.dart';
import 'package:my_appliances/repo/image_storage.dart';
import 'package:my_appliances/repo/item_service.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_notifier.dart';
import 'package:my_appliances/utils/logger.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  bool _suggetPriceSelected = false;

  TextEditingController _priceController = TextEditingController();

  var _border = UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.transparent
      )
  );

  var _divider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[350],
    indent: common_bg_padding,
    endIndent: common_bg_padding,
  );

  bool isCreatingItem = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async{
    //현재유저 로그인 상태일때만 (null일떄는 빈값 리턴)
    if(FirebaseAuth.instance.currentUser == null) return;
    isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String itemKey = ItemModel.generateItemKey(userKey);
    logger.d('Generated itemKey: $itemKey');

    List<Uint8List> images = context.read<SelectImageNotifier>().images;
    logger.d('Selected images count: ${images.length}');

    if(images.isEmpty){
      logger.e('No images selected.');
      return;
    }

    UserNotifier userNotifier = context.read<UserNotifier>();

    if(userNotifier.userModel == null) {
      logger.d('userModel is null.');
      return;
    }

    List<String> downloadUrls =
    await ImageStorage.uploadImages(images, itemKey);
    logger.d('downloadUrls accepted successfully: $downloadUrls');

    final num? price =
    num.tryParse(_priceController.text.replaceAll(new RegExp(r"\D"), ''));

    ItemModel itemModel = ItemModel(
        itemKey: itemKey,
        userKey: userKey,
        imageDownloadUrls: downloadUrls,
        title: _titleController.text,
        category: context.read<CategoryNotifier>().currentCategoryInEng,
        price: price??0,
        negotiable: _suggetPriceSelected,
        detail: _detailController.text,
        createdDate: DateTime.now().toUtc(),
    );

    await ItemService().createNewItem(itemModel.toJson(), itemKey);

    context.pop();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery
            .of(context)
            .size;
        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 2),
                child: isCreatingItem
                    ? LinearProgressIndicator(minHeight: 2)
                    : Container(),
              ),
              leading: TextButton(
                onPressed: () {
                  context.pop();
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Theme
                        .of(context)
                        .appBarTheme
                        .backgroundColor
                ),
                child: Text('뒤로',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium
                ),
              ),
              actions: [
                TextButton(
                  onPressed: attemptCreateItem,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Theme
                          .of(context)
                          .appBarTheme
                          .backgroundColor
                  ),
                  child: Text('완료',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                  ),
                ),
              ],
              title: Text('가전제품 등록',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                MultiImageSelect(),
                SizedBox(
                  height: 15,
                ),
                _divider,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '제품명',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
                _divider,
                ListTile(
                  onTap: () {
                    context.push('/input/category_input');
                  },
                  dense: true,
                  title: Text(context
                      .watch<CategoryNotifier>()
                      .currentCategoryInKor),
                  trailing: Icon(Icons.navigate_next),
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            CurrencyInputFormatter(
                                trailingSymbol: '원',
                                mantissaLength: 0
                            ),
                          ],
                          controller: _priceController,
                          onChanged: (value) {
                            setState(() {
                              if (value == '0원') {
                                _priceController.clear();
                              }
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: common_bg_padding
                            ),
                            hintText: '구매가격을 입력하세요',
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: common_bg_padding),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _suggetPriceSelected = !_suggetPriceSelected;
                          });
                        },
                        label: Text(
                          '가격 제안 받기',
                          style: TextStyle(
                              color: _suggetPriceSelected
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : Colors.black54
                          ),
                        ),
                        icon: Icon(
                          _suggetPriceSelected
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: _suggetPriceSelected
                              ? Theme
                              .of(context)
                              .primaryColor
                              : Colors.black54,
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black38
                        ),
                      ),
                    ),
                  ],
                ),
                _divider,
                TextFormField(
                  controller: _detailController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '추가 메모 사항이 있다면 남겨보세요.',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

