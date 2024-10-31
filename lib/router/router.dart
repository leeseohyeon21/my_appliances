import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/screens/home_screen.dart';
import 'package:my_appliances/screens/start_screen.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userState = context.read<UserProvider>().userState;
    print("User state: $userState");
    return userState ? null : '/start';
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/start',
      builder: (context, state) => StartScreen(),
    ),
  ],
);
