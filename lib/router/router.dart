import 'package:go_router/go_router.dart';
import 'package:my_appliances/input/label_recognition.dart';
import 'package:my_appliances/input/label_scan_screen.dart';
import 'package:my_appliances/input/register_screen.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/screens/item/purchase_product_detail.dart';
import 'package:my_appliances/screens/item/rental_product_detail.dart';
import 'package:my_appliances/screens/notification/notifications_screen.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_notifier.dart';
import 'package:provider/provider.dart';

const LOCATION_HOME = 'home';
const LOCATION_LABEL_SCAN = 'label_scan';
const LOCATION_LABEL_RECOGNITION = 'label_recognition';
const LOCATION_INPUT = 'input';
const LOCATION_REGISTER = 'register';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_PURCHASE_INPUT = 'purchase_input';
const LOCATION_ITEM = 'item';
const LOCATION_ITEM_ID = 'item_id';
const LOCATION_PURCHASE_PRODUCT = 'purchase_product';
const LOCATION_RENTAL_PRODUCT = 'rental_product';
const LOCATION_PRODUCT_ID = 'product_id';
const LOCATION_EDITPURCHASE = 'edit_purchase';
const LOCATION_EDITRENTAL = 'edit_rental';
const LOCATION_NOTIFICATIONS = 'notifications';

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
      path: '/$LOCATION_LABEL_SCAN',
      builder: (context, state) => LabelScanScreen(),
    ),
    GoRoute(
      path: '/$LOCATION_LABEL_RECOGNITION',
      builder: (context, state) => LabelRecognitionScreen(),
    ),
    GoRoute(
      path: '/$LOCATION_REGISTER',
      builder: (context, state) {
        final initialModelName = state.extra as String? ?? "";

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => SelectImageNotifier()),
          ],
          child: RegisterScreen(initialModelName: initialModelName),
        );
      },
    ),
    GoRoute(
      path: '/$LOCATION_PURCHASE_PRODUCT/:$LOCATION_PRODUCT_ID',
      builder: (context, state) {
        final productKey = state.pathParameters[LOCATION_PRODUCT_ID] ?? '';
        return PurchaseProductDetailScreen(productKey);
      },
    ),
    GoRoute(
      path: '/$LOCATION_RENTAL_PRODUCT/:$LOCATION_PRODUCT_ID',
      builder: (context, state) {
        final productKey = state.pathParameters[LOCATION_PRODUCT_ID] ?? '';
        return RentalProductDetailScreen(productKey);
      },
    ),
    GoRoute(
      path: '/$LOCATION_NOTIFICATIONS',
      builder: (context, state) => NotificationsScreen(),
    ),
  ],
);
