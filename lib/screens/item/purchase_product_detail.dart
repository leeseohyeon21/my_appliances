import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/data/purchase_product_model.dart';
import 'package:my_appliances/repo/purchase_product_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PurchaseProductDetailScreen extends StatefulWidget {
  final String productKey;
  const PurchaseProductDetailScreen(this.productKey, {Key? key}) : super(key: key);

  @override
  _PurchaseProductDetailScreenState createState() => _PurchaseProductDetailScreenState();
}

class _PurchaseProductDetailScreenState extends State<PurchaseProductDetailScreen> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();

  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;

  Widget _divider = Divider(
    height: 1,
    thickness: 1,
    indent: common_bg_padding,
    endIndent: common_bg_padding,
  );

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null || _statusBarHeight == null)
        return;
      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PurchaseProductModel>(
      future: PurchaseProductService().getItem(widget.productKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PurchaseProductModel purchaseProductModel = snapshot.data!;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _size = MediaQuery.of(context).size;
              _statusBarHeight = MediaQuery.of(context).padding.top;
              return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          _imagesAppBar(purchaseProductModel, context),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              _divider,
                              Padding(
                                padding: const EdgeInsets.all(common_bg_padding*2),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '모델명 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                              purchaseProductModel.modelName, style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '제품명 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(purchaseProductModel.productName, style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '브랜드 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(purchaseProductModel.brand, style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '구매날짜 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(DateFormat('yyyy년 MM월 dd일').format(purchaseProductModel.purchaseDate),
                                              style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '구매가격 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text('${NumberFormat('###,###,###').format(purchaseProductModel.price)}원',
                                              style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '무상A/S기간 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text('${NumberFormat('###,###,###').format(purchaseProductModel.ASPeriod)}년',
                                              style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100, // 필드명의 고정 폭
                                          child: Text(
                                              '추가메모 : ',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(purchaseProductModel.memo, style: Theme.of(context).textTheme.titleLarge),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: common_bg_padding),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            context.push('/edit_purchase/:${widget.productKey}');
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black87,
                                              backgroundColor: Theme.of(context).appBarTheme.backgroundColor
                                          ),
                                          child: Text('수정', style: Theme.of(context).textTheme.bodyMedium),
                                        ),
                                        SizedBox(width: common_bg_padding),
                                        TextButton(
                                          onPressed: (){
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black87,
                                              backgroundColor: Theme.of(context).appBarTheme.backgroundColor
                                          ),
                                          child: Text('삭제', style: Theme.of(context).textTheme.bodyMedium),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Container(
                        height: kToolbarHeight + _statusBarHeight!,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black12,
                                Colors.black12,
                                Colors.black12,
                                Colors.black12,
                                Colors.transparent
                              ],
                            )),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          shadowColor: Colors.transparent,
                          backgroundColor: isAppbarCollapsed
                              ? Colors.white
                              : Colors.transparent,
                          foregroundColor:
                          isAppbarCollapsed ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ),
                  ]);
            },
          );
        }
        return Container();
      },
    );
  }

  SliverAppBar _imagesAppBar(PurchaseProductModel purchaseProductModel, BuildContext context) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: SmoothPageIndicator(
            controller: _pageController, // PageController
            count: purchaseProductModel.imageDownloadUrls.length,
            effect: WormEffect(
                dotColor: Theme.of(context).colorScheme.background,
                activeDotColor: Theme.of(context).primaryColor,
                radius: 2,
                dotHeight: 4,
                dotWidth: 4), // yo// ur preferred effect
            onDotClicked: (index) {}),
        centerTitle: true,
        background: PageView.builder(
          controller: _pageController,
          allowImplicitScrolling: true,
          itemBuilder: (BuildContext context, int index) {
            return ExtendedImage.network(
              purchaseProductModel.imageDownloadUrls[index],
              fit: BoxFit.cover,
              //scale: 0.1,
            );
          },
          itemCount: purchaseProductModel.imageDownloadUrls.length,
        ),
      ),
    );
  }
}