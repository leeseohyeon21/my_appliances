import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:provider/provider.dart';

class CategoryInputScreen extends StatelessWidget {
  const CategoryInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상품 카테고리 선택',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                context.read<CategoryNotifier>().setNewCategoryWithKor(
                  categoriesMapEngToKor.values.elementAt(index));
                context.pop();
              },
                title: Text(
                    categoriesMapEngToKor.values.elementAt(index),
                style: TextStyle(color:
                context.read<CategoryNotifier>().setNewCategoryWithKor == categoriesMapEngToKor.values.elementAt(index)
                ?Theme.of(context).primaryColor
                :Colors.black87),
                ));
          },
          separatorBuilder: (context, index){
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300]
            );
          },
          itemCount: categoriesMapKorToEng.length),
    );
  }
}

const List<String> categories = [
  '선택', '패션', '아동', '전자제품', '가구', '스포츠', '화장품'
];
