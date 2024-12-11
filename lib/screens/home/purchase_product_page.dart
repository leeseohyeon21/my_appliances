import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/data/purchase_product_model.dart';
import 'package:my_appliances/repo/purchase_product_service.dart';
import 'package:my_appliances/router/router.dart';
import 'package:my_appliances/utils/logger.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseProductPage extends StatelessWidget {
  const PurchaseProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 3;

        return FutureBuilder<List<PurchaseProductModel>>(
            future: PurchaseProductService().getItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return _listView(imgSize, snapshot.data!);
              } else {
                return _shimmerListView(imgSize);
              }
            });
      },
    );
  }

  ListView _listView(double imgSize, List<PurchaseProductModel> products) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: common_bg_padding),
      padding: EdgeInsets.all(common_bg_padding),
      itemCount: products.length,
      itemBuilder: (context, index) {
        PurchaseProductModel product = products[index];
        return InkWell(
          onTap: () {
            context.push('/$LOCATION_PURCHASE_PRODUCT/:${product.productKey}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imgSize,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExtendedImage.network(
                    product.imageDownloadUrls[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8), // 사진과 제품명 사이의 간격
              Text(
                product.productName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(common_bg_padding),
        separatorBuilder: (context, index) => SizedBox(height: common_bg_padding),
        itemCount: 50,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: imgSize,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 8), // 사진과 제품명 사이의 간격
              Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
