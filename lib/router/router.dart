import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/screens/start/auth_page.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user == null) {
      return '/';
    }
    return '/home';
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
  ],
);
