import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/pages/home.dart';
import 'package:animations/animations.dart';
import 'package:mymy_m1/pages/settings/settings.dart';
import 'package:mymy_m1/navigation/main_wrapper.dart';

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

// GoRouter configurations
final _router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    /// MainWrapper
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainWrapper(
          navigationShell: navigationShell,
        );
      },
      branches: [
        /// Brach Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHome,
          routes: <RouteBase>[
            GoRoute(
              name: 'Home',
              path: '/',
              // builder: (context, state) => const HomePage(title: "myMY M1"),
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(title: "myMY M1"),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Change the opacity of the screen using a Curve based on the the animation's
                    // value
                    return FadeThroughTransition(
                      fillColor: Theme.of(context).hoverColor,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                );
              },
              routes: [
                GoRoute(
                  path: 'subHome',
                  name: 'SubHome',
                  pageBuilder: (context, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const Text("sub home"),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                ),
              ],
            ),
          ],
        ),

        /// Brach Setting
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettings,
          routes: <RouteBase>[
            GoRoute(
              path: "/settings",
              name: "Settings",
              builder: (BuildContext context, GoRouterState state) =>
                  const Settings(),
              routes: [
                GoRoute(
                  path: "subSettings",
                  name: "SubSettings",
                  pageBuilder: (context, state) {
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const Text('sub settings'),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) =>
                          FadeTransition(opacity: animation, child: child),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // GoRoute(
    //   name: 'transactionRecords',
    //   path: 'records',
    //   parentNavigatorKey: _rootNavigatorKey,
    // )
  ],
);

// Export the router instance
GoRouter get router => _router;
