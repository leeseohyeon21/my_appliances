import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/data/item_model.dart';
import 'package:my_appliances/input/category_input_screen.dart';
import 'package:my_appliances/input/multi_image_select.dart';
import 'package:my_appliances/repo/image_store.dart';
import 'package:my_appliances/repo/item_service.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:my_appliances/utils/logger.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  var _divider = Divider(
    height: 1,
    color: Colors.grey[300],
    thickness: 1,
    indent: common_bg_padding,
    endIndent: common_bg_padding,
  );

  var _border = UnderlineInputBorder(
    borderSide: BorderSide(
    color: Colors.transparent
    )
  );

  bool _suggetPriceSelected = false;

  TextEditingController _priceController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _DetailController = TextEditingController();

  bool isCreatingItem = false;

  void attemptCreateItem() async{
    //현재유저 로그인 상태일때만 (null일떄는 빈값 리턴)
    if(FirebaseAuth.instance.currentUser == null) return;
    isCreatingItem = true;
    setState(() {});

    final String itemKey = ItemModel.generateItemKey(FirebaseAuth.instance.currentUser!.uid);
    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final num? price = num.tryParse(_priceController.text.replaceAll('.', '').replaceAll('원', ''));

    List<Uint8List> images = context.read<SelectImageNotifier>().images;
    List<String> downloadUrls = await ImageStorage.uploadImages(images, itemKey);

    UserProvider userProvider = context.read<UserProvider>();
    if(userProvider.userModel == null) return;

    ItemModel itemModel = ItemModel(
        itemKey: itemKey,
        userKey: userKey,
        imageDownloadUrls: downloadUrls,
        title: _titleController.text,
        category: context.read<CategoryNotifier>().currentCategoryInEng,
        price: price??0,
        negotiable: _suggetPriceSelected,
        detail: _DetailController.text,
        createdDate: DateTime.now().toUtc(),
    );

    logger.d('upload finished - ${downloadUrls.toString()}');

    await ItemService().createNewItem(itemModel.toJson(), itemKey);

    isCreatingItem = false;
    setState(() {

    });
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
                  onPressed: () async {

                  },
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
              title: Text('가전제품 등록'),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                MultiImageSelect(),
                _divider,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '상품 제목',
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
                            hintText: '상품가격을 입력하세요',
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
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '상품 및 필요한 세부설명을 입력해주세요.',
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

