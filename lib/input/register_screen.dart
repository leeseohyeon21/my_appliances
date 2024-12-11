import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/data/lental_product_model.dart';
import 'package:my_appliances/data/purchase_product_model.dart';
import 'package:my_appliances/input/multi_image_select.dart';
import 'package:my_appliances/repo/image_storage.dart';
import 'package:my_appliances/repo/lental_product_service.dart';
import 'package:my_appliances/repo/purchase_product_service.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_notifier.dart';
import 'package:my_appliances/utils/logger.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final String initialModelName;

  const RegisterScreen({super.key, required this.initialModelName});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isCreatingProduct = false;
  bool _isSelectionVisible = false; // 구매/렌탈 UI가 보이는지 여부
  bool _isNextButtonPressed = false; // '다음 입력하기' 버튼이 눌렸는지 여부
  String? _selectedOption; // "구매" 또는 "렌탈"

  TextEditingController _modelNameController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _brandNameController = TextEditingController();

  //구매제품
  TextEditingController _purchaseDateController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _ASPeriodController = TextEditingController();
  TextEditingController _purchaseMemoController = TextEditingController();
  //렌탈제품
  TextEditingController _lentalDateController = TextEditingController();
  TextEditingController _terminalDateController = TextEditingController();
  TextEditingController _dutyPeriodController = TextEditingController();
  TextEditingController _managementController = TextEditingController();
  TextEditingController _firstPriceController = TextEditingController();
  TextEditingController _monthPriceController = TextEditingController();
  TextEditingController _lentalMemoController = TextEditingController();

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

  void attemptCreatePurchaseProduct() async{
    //현재유저 로그인 상태일때만 (null일떄는 빈값 리턴)
    if(FirebaseAuth.instance.currentUser == null) return;
    isCreatingProduct = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String productKey = PurchaseProductModel.generateProductKey(userKey);
    logger.d('Generated productKey: $productKey');

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
    await ImageStorage.uploadImages(images, productKey);
    logger.d('downloadUrls accepted successfully: $downloadUrls');

    final num? price =
    num.tryParse(_priceController.text.replaceAll(new RegExp(r"\D"), ''));

    final num? ASPeriod =
    num.tryParse(_ASPeriodController.text.replaceAll(new RegExp(r"\D"), ''));

    PurchaseProductModel purchaseProductModel = PurchaseProductModel(
      productKey: productKey,
      userKey: userKey,
      imageDownloadUrls: downloadUrls,
      modelName: _modelNameController.text,
      productName: _productNameController.text,
      brand: _brandNameController.text,
      purchaseDate: DateFormat('yyyy-MM-dd').parse(_purchaseDateController.text).toUtc(),
      price: price??0,
      ASPeriod: ASPeriod??0,
      memo: _purchaseMemoController.text,
      createdDate: DateTime.now().toUtc(),
    );

    logger.d('upload finished - ${downloadUrls.toString()}');

    await PurchaseProductService()
        .createNewProduct(purchaseProductModel, productKey, userNotifier.user!.uid);

    context.go('/home');

  }

  void attemptCreateLentalProduct() async{
    //현재유저 로그인 상태일때만 (null일떄는 빈값 리턴)
    if(FirebaseAuth.instance.currentUser == null) return;
    isCreatingProduct = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String productKey = PurchaseProductModel.generateProductKey(userKey);
    logger.d('Generated productKey: $productKey');

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
    await ImageStorage.uploadImages(images, productKey);
    logger.d('downloadUrls accepted successfully: $downloadUrls');

    final num? dutyPeriod =
    num.tryParse(_dutyPeriodController.text.replaceAll(new RegExp(r"\D"), ''));

    final num? firstPrice =
    num.tryParse(_firstPriceController.text.replaceAll(new RegExp(r"\D"), ''));

    final num? monthPrice =
    num.tryParse(_monthPriceController.text.replaceAll(new RegExp(r"\D"), ''));

    LentalProductModel lentalProductModel = LentalProductModel(
      productKey: productKey,
      userKey: userKey,
      imageDownloadUrls: downloadUrls,
      modelName: _modelNameController.text,
      productName: _productNameController.text,
      brand: _brandNameController.text,
      lentalDate: DateFormat('yyyy-MM-dd').parse(_lentalDateController.text).toUtc(),
      terminalDate: DateFormat('yyyy-MM-dd').parse(_terminalDateController.text).toUtc(),
      dutyPeriod: dutyPeriod??0,
      management: _managementController.text,
      firstPrice: firstPrice??0,
      monthPrice: monthPrice??0,
      memo: _lentalMemoController.text,
      createdDate: DateTime.now().toUtc(),
    );

    logger.d('upload finished - ${downloadUrls.toString()}');

    await LentalProductService()
        .createNewProduct(lentalProductModel, productKey, userNotifier.user!.uid);

    context.go('/home');

  }

  @override
  void initState() {
    super.initState();
    _modelNameController.text = widget.initialModelName;
    _modelNameController.addListener(_checkButtonState);
    _productNameController.addListener(_checkButtonState);
    _brandNameController.addListener(_checkButtonState);
  }

  // 버튼 활성화 여부 체크
  void _checkButtonState() {
    setState(() {}); // 상태 갱신
  }

  bool get _isButtonEnabled {
    return _modelNameController.text.isNotEmpty &&
        _productNameController.text.isNotEmpty &&
        _brandNameController.text.isNotEmpty;
  }

  Widget _buildPurchaseRentalSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _divider,
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('구매 제품'),
                value: "구매",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() => _selectedOption = value);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('렌탈 제품'),
                value: "렌탈",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() => _selectedOption = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldsBasedOnSelection() {
    if (_selectedOption == "구매") {
      return _buildPurchaseFields();
    } else if (_selectedOption == "렌탈") {
      return _buildRentalFields();
    }
    return const SizedBox.shrink();
  }

  Widget _buildPurchaseFields() {
    return Column(
      children: [
        _divider,
        TextFormField(
          controller: _purchaseDateController,
          readOnly: true, // 직접 입력 방지
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: common_bg_padding),
            hintText: '구매시기를 선택하세요.',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          onTap: () async {
            // 달력 표시
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), // 선택 가능한 시작 날짜
              lastDate: DateTime.now(), // 현재 날짜까지 선택 가능
            );

            if (selectedDate != null) {
              // 선택한 날짜를 포맷팅하여 컨트롤러에 입력
              setState(() {
                _purchaseDateController.text =
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              });
            }
          },
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
          ],
        ),
        _divider,
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  inputFormatters: [
                    CurrencyInputFormatter(
                        trailingSymbol: '년',
                        mantissaLength: 0
                    ),
                  ],
                  controller: _ASPeriodController,
                  onChanged: (value) {
                    setState(() {
                      if (value == '0년') {
                        _ASPeriodController.clear();
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '무상A/S기간을 입력하세요',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                )
            ),
          ],
        ),
        _divider,
        TextFormField(
          controller: _lentalMemoController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: common_bg_padding,  // 좌우 여백은 그대로 유지
                vertical: 100.0                  // 상하 여백을 16으로 설정하여 높이를 30으로 맞춤
            ),
            hintText: '추가 메모 사항',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          textAlignVertical: TextAlignVertical.top,  // 텍스트를 위쪽에 정렬
          keyboardType: TextInputType.multiline,    // 여러 줄 입력을 허용
          maxLines: null,                          // 최대 줄 수 제한 없앰
        )
      ],
    );
  }

  Widget _buildRentalFields() {
    return Column(
      children: [
        _divider,
        TextFormField(
          controller: _lentalDateController,
          readOnly: true, // 직접 입력 방지
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: common_bg_padding),
            hintText: '렌탈날짜를 선택하세요.',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          onTap: () async {
            // 달력 표시
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), // 선택 가능한 시작 날짜
              lastDate: DateTime.now(), // 현재 날짜까지 선택 가능
            );

            if (selectedDate != null) {
              // 선택한 날짜를 포맷팅하여 컨트롤러에 입력
              setState(() {
                _lentalDateController.text =
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              });
            }
          },
        ),
        _divider,
        TextFormField(
          controller: _terminalDateController,
          readOnly: true, // 직접 입력 방지
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: common_bg_padding),
            hintText: '렌탈종료날짜를 선택하세요.',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          onTap: () async {
            // 달력 표시
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), // 선택 가능한 시작 날짜
              lastDate: DateTime.now().add(Duration(days: 365 * 10)), // 현재 날짜까지 선택 가능
            );

            if (selectedDate != null) {
              // 선택한 날짜를 포맷팅하여 컨트롤러에 입력
              setState(() {
                _terminalDateController.text =
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              });
            }
          },
        ),
        _divider,
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  inputFormatters: [
                    CurrencyInputFormatter(
                        trailingSymbol: '개월',
                        mantissaLength: 0
                    ),
                  ],
                  controller: _dutyPeriodController,
                  onChanged: (value) {
                    setState(() {
                      if (value == '0개월') {
                        _dutyPeriodController.clear();
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '의무 사용 기간을 입력하세요.',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                )
            ),
          ],
        ),
        _divider,
        DropdownButtonFormField<String>(
          value: _managementController.text.isNotEmpty ? _managementController.text : null,
          items: const [
            DropdownMenuItem(value: "직접 관리", child: Text('직접 관리')),
            DropdownMenuItem(value: "방문 주기", child: Text('방문 주기')),
          ],
          onChanged: (value) {
            if (value != null) {
              _managementController.text = value; // 선택된 값을 컨트롤러에 저장
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: common_bg_padding
            ),
            hintText: '관리유형을 선택하세요',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
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
                  controller: _firstPriceController,
                  onChanged: (value) {
                    setState(() {
                      if (value == '0원') {
                        _firstPriceController.clear();
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '선납금을 입력하세요',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                )
            ),
          ],
        ),
        _divider,
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  inputFormatters: [
                    CurrencyInputFormatter(
                        trailingSymbol: '원/월',
                        mantissaLength: 0
                    ),
                  ],
                  controller: _monthPriceController,
                  onChanged: (value) {
                    setState(() {
                      if (value == '0년/월') {
                        _monthPriceController.clear();
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: common_bg_padding
                    ),
                    hintText: '월 렌탈료를 입력하세요.',
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                  ),
                )
            ),
          ],
        ),
        _divider,
        TextFormField(
          controller: _lentalMemoController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: common_bg_padding,  // 좌우 여백은 그대로 유지
                vertical: 100.0                  // 상하 여백을 16으로 설정하여 높이를 30으로 맞춤
            ),
            hintText: '추가 메모 사항',
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          textAlignVertical: TextAlignVertical.top,  // 텍스트를 위쪽에 정렬
          keyboardType: TextInputType.multiline,    // 여러 줄 입력을 허용
          maxLines: null,                          // 최대 줄 수 제한 없앰
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          Size _size = MediaQuery.of(context).size;
          return IgnorePointer(
            ignoring: isCreatingProduct,
            child: Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                  preferredSize: Size(_size.width, 2),
                  child: isCreatingProduct
                      ? LinearProgressIndicator(minHeight: 2)
                      :Container(),
                ),
                leading: TextButton(
                  onPressed: (){
                    context.pop();
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Theme.of(context).appBarTheme.backgroundColor
                  ),
                  child: Text('뒤로', style: Theme.of(context).textTheme.bodyMedium),
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      if(_selectedOption == "구매"){
                        attemptCreatePurchaseProduct();
                      }else if(_selectedOption == "렌탈"){
                        attemptCreateLentalProduct();
                      }
                    },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Theme.of(context).appBarTheme.backgroundColor
                      ),
                    child: Text('완료', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
                title: Text('가전제품 등록',
                  style: Theme.of(context).textTheme.titleLarge,
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
                    controller: _modelNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: common_bg_padding
                      ),
                      hintText: '모델명',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                  _divider,
                  TextFormField(
                    controller: _productNameController,
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
                  TextFormField(
                    controller: _brandNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: common_bg_padding
                      ),
                      hintText: '브랜드',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                  _divider,
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                      setState(() {
                        _isNextButtonPressed = true;
                        _isSelectionVisible = true; // 제품 유형 선택 UI 보이기
                      });
                    }
                        : null,
                    child: const Text('다음 입력하기'),
                  ),

                  //'다음 입력하기' 버튼 누른 후
                  if(_isNextButtonPressed) _buildPurchaseRentalSelection(),

                  //제품 유형 선택 후
                  if(_isSelectionVisible)...[
                    _buildFieldsBasedOnSelection(),
                  ],

                  //등록하기 버튼 추가
                  // if(_isSelectionVisible)...[
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('제품이 성공적으로 등록되었습니다!')),
                  //       );
                  //       Navigator.pop(context);
                  //     },
                  //     child: const Text('등록하기'),
                  //   ),
                  // ],
                ],
              ),
            ),
          );
        });
  }
}
