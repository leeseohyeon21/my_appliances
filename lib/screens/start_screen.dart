import 'package:flutter/material.dart';
import 'package:my_appliances/screens/start/address_page.dart';
import 'package:my_appliances/screens/start/auth_page.dart';
import 'package:my_appliances/screens/start/intro_page.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  //페이지 컨트롤러
  PageController _pageController = PageController();

  StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            IntroPage(),
            AuthPage(),
            AddressPage(),
          ],
        ),
      ),
    );
  }
}
