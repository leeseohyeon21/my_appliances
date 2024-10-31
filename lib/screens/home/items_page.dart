import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_appliances/constants/common_size.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){

        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 3,  //높이
              thickness: 1, //구분선
              color: Colors.grey[200],  //구분선 색
              indent: common_sm_padding,  //좌측 구분선 패딩
              endIndent: common_sm_padding, //우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            return SizedBox(
              height: imgSize,
              child: Row(
                children: [
                  SizedBox(
                      height: imgSize,
                      width: imgSize,
                      child: ExtendedImage.network(
                        'https://picsum.photos/100',
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                  ),
                  SizedBox(width: common_bg_padding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('어린이용 범퍼카', style: Theme.of(context).textTheme.titleLarge,),
                        SizedBox(height: 7),
                        Text('1시간 전', style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 7),
                        Text('15,000 원'),
                        Expanded(child: Container(),),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 15,
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.chat_bubble_2, color: Colors.grey,),
                                      Text('31', style: TextStyle(color: Colors.grey),),
                                      Icon(CupertinoIcons.heart, color: Colors.grey),
                                      Text('31', style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: 10,);
      }
    );
  }
}
