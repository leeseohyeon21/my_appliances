import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:my_appliances/data/item_model.dart';
import 'package:my_appliances/screens/item/item_detail_screen.dart';

class SimilarItem extends StatelessWidget {
  const SimilarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 9 / 8,
            child: ExtendedImage.network(
                'https://picsum.photos/200',
                fit: BoxFit.cover,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8)),
          ),
          SizedBox(height: 8),
          Text(
            '워터파크 교환권을 아주 싸게 팝니다.',
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Text('16000원',
              style: Theme.of(context).textTheme.titleSmall),
        ],
    );
  }
}