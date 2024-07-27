import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/pages/analytics.dart';
import 'package:mymy_m1/pages/authentication/reset_password_page.dart';
import 'package:mymy_m1/pages/home.dart';
import 'package:mymy_m1/pages/new_transaction/new_transaction.dart';
import 'package:mymy_m1/pages/records.dart';
import 'package:mymy_m1/pages/settings/settings.dart';
import 'package:mymy_m1/navigation/nav_bar.dart';
import 'package:mymy_m1/navigation/start.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
  initialLocation: '/start',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return NavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'Home',
          builder: (context, state) => const HomePage(title: "myMY"),
          routes: [
            GoRoute(
              path: 'subHome',
              name: 'SubHome',
              builder: (context, state) => const Text("sub home"),
            ),
          ],
        ),
        GoRoute(
          path: '/records',
          name: 'Records',
          builder: (context, state) => const Records(),
        ),
        GoRoute(
          path: '/analytics',
          name: 'Analytics',
          builder: (context, state) => const Analytics(),
        ),
        GoRoute(
          path: '/settings',
          name: 'Settings',
          builder: (context, state) => Settings(),
          routes: [
            GoRoute(
              path: 'subSettings',
              name: 'SubSettings',
              builder: (context, state) => const Text('sub settings'),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/new',
      name: 'NewTransaction',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NewTransaction(),
    ),
    GoRoute(
      path: '/start',
      name: 'Start',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => Start(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'ResetPasswordPage',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ],
);
