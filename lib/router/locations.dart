import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_appliances/screens/start_screen.dart';
import '../screens/start/auth_page.dart';
import '../screens/home_screen.dart';

class HomeLocation extends BeamLocation<BeamState>{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    return [
      BeamPage(
        child: StartScreen(),
        key: ValueKey('home'),
      ),
    ];
  }

  @override
  List<String> get pathPatterns => ['/'];
}