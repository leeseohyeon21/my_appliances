import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_appliances/input/category_input_screen.dart';
import 'package:my_appliances/input/input_screen.dart';
import 'package:my_appliances/screens/item/item_detail_screen.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:provider/provider.dart';

const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';

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
        key: ValueKey('category_input')
      )
    ];
  }

  @override
  List<String> get pathPatterns => ['/input'];

}

class ItemLocation extends BeamLocation<BeamState> {

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state){
    throw [
      ...HomeLocation().buildPages(context, state),
      if(state.pathParameters.containsKey(LOCATION_ITEM_ID))
        BeamPage(
          child: ItemDetailScreen(state.pathParameters[LOCATION_ITEM_ID] ?? ''),
          key: ValueKey(LOCATION_ITEM_ID)
        )
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/$LOCATION_ITEM:$LOCATION_ITEM_ID'];

}