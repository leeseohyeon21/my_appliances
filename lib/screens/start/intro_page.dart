import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {

  IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('나의 가전',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),

              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(" '나의 가전'은 가정 내 가전제품을\n체계적으로 기록하고, 상태와 사용 이력을\n효율적으로 관리할 수 있도록 돕는\n어플리케이션입니다.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                    onPressed: () async {
                      context.read<PageController>().animateToPage(
                          1,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeOut);
                    },
                    child: Text('로그인하고 시작하기',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
