import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:my_appliances/utils/logger.dart';

class IntroPage extends StatelessWidget {

  IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('current user state: ${context.read<UserProvider>().userState}');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('나의 가전',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            ExtendedImage.asset('assets/images/temp.jpg'),
            Text('가전제품 기록 앱',
              //style: Theme.of(context).textTheme.headlineSmall,
              style: TextStyle(
                //color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.w500),
            ),
            Text('가정내 가전제품을 기록해 두고 효과적으로 관리해봐요.',
              style: TextStyle(fontSize: 13),
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
