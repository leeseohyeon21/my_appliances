import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  TextEditingController _addressController = TextEditingController();

  @override
  void dispose(){
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                prefixIconConstraints: BoxConstraints(
                    minWidth: 24,
                    minHeight: 24
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey),
                  ),
                  hintText: '도로명으로 검색하세요.',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
              ),),
            TextButton.icon(
              onPressed: (){},
              icon: Icon(
                CupertinoIcons.compass,
                color: Colors.white
              ),
              label: Text('현재 위치로 찾기',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: 30,
                itemBuilder: (context, index){
                  return ListTile(
                    onTap: (){
                      context.read<PageController>().animateToPage(
                          2,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeOut);
                    },
                    title: Text('address $index'),
                    subtitle: Text('details $index'),
                  );
                }
              ),
            ),
          ],),
      )
    );
  }
}
