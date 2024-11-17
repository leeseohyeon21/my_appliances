import 'package:go_router/go_router.dart';
import 'package:my_appliances/input/category_input_screen.dart';
import 'package:my_appliances/input/input_screen.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/screens/item/item_detail_screen.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_notifier.dart';
import 'package:provider/provider.dart';

const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    final userState = userNotifier.user;

    if (userState == null && state.uri.toString() != '/') {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => StartScreen(),
    ),
    GoRoute(
      path: '/$LOCATION_HOME',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/$LOCATION_INPUT',
      builder: (context, state) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: categoryNotifier),
            ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
          ],
          child: InputScreen(),
          );
      },
    ),
    GoRoute(
      path: '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT',
      builder: (context, state) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: categoryNotifier),
            ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
          ],
          child: CategoryInputScreen(),
        );
      },
    ),
    GoRoute(
      path: '/$LOCATION_ITEM/:$LOCATION_ITEM_ID',
      builder: (context, state) {
        final itemId = state.pathParameters[LOCATION_ITEM_ID] ?? '';
        return ItemDetailScreen(itemId);
      },
    ),
  ],
);
