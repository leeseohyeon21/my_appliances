import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_appliances/input/category_input_screen.dart';
import 'package:my_appliances/input/input_screen.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/screens/start/auth_page.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:provider/provider.dart';

class HomeLocation extends BeamLocation<BeamState>{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    return [BeamPage(child: HomeScreen(), key: ValueKey('home'),),];
  }

  @override
  List<String> get pathPatterns => ['/'];
}

class InputLocation extends BeamLocation<BeamState> {

  @override
  Widget builder (BuildContext context, Widget navigator){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: categoryNotifier),
        ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
      ],
        child: super.builder(context, navigator)
    );
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    return [
      ...HomeLocation().buildPages(context, state),
      if(state.pathPatternSegments.contains('input'))
      BeamPage(
          child: InputScreen(),
          key: ValueKey('input')
      ),
    if(state.pathPatternSegments.contains('category_input'))
      BeamPage(
        child: CategoryInputScreen(),
        key: ValueKey('category_inpu')
      )
    ];
  }

  @override
  List<String> get pathPatterns => ['/input'];

}