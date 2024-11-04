import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/input/category_input_screen.dart';
import 'package:my_appliances/input/input_screen.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/screens/start/auth_page.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/states/category_notifier.dart';
import 'package:my_appliances/states/select_image_notifier.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user == null) {
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
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/input',
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
      path: '/input/category_input',
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
  ],
);
