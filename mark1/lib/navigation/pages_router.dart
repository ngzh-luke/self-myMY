import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/pages/analytics.dart';
import 'package:mymy_m1/pages/authentication/login_and_register_screen.dart';
import 'package:mymy_m1/pages/home.dart';
import 'package:animations/animations.dart';
import 'package:mymy_m1/pages/new_transaction/new_transaction.dart';
import 'package:mymy_m1/pages/records.dart';
import 'package:mymy_m1/pages/settings/settings.dart';
import 'package:mymy_m1/navigation/main_wrapper.dart';
import 'package:mymy_m1/services/start.dart';

// Private navigators
final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "rootNavigator");
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorRecords =
    GlobalKey<NavigatorState>(debugLabel: 'shellRecords');
final _shellNavigatorSettings =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
final _shellNavigatorNewTransaction =
    GlobalKey<NavigatorState>(debugLabel: 'shellAddTransaction');
final _shellNavigatorAnalytics =
    GlobalKey<NavigatorState>(debugLabel: "shellNavigatorAnalytics");

// GoRouter configurations
final _router = GoRouter(
  initialLocation: '/gateway',
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
                  child: const HomePage(title: "myMY"),
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

        /// Brach Records
        StatefulShellBranch(
            navigatorKey: _shellNavigatorRecords,
            routes: <RouteBase>[
              GoRoute(
                  path: '/records',
                  name: 'Records',
                  builder: (BuildContext context, GoRouterState state) =>
                      const Records())
            ]),

        /// Brach Analytics
        StatefulShellBranch(
            navigatorKey: _shellNavigatorAnalytics,
            routes: <RouteBase>[
              GoRoute(
                  path: '/analytics',
                  name: 'Analytics',
                  builder: (BuildContext context, GoRouterState state) =>
                      const Analytics())
            ]),

        /// Brach Setting
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettings,
          routes: <RouteBase>[
            GoRoute(
              path: "/settings",
              name: "Settings",
              builder: (BuildContext context, GoRouterState state) =>
                  Settings(),
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

        /// New transaction
        StatefulShellBranch(
            navigatorKey: _shellNavigatorNewTransaction,
            routes: <RouteBase>[
              GoRoute(
                  name: 'NewTransaction',
                  path: '/new',
                  builder: (BuildContext context, GoRouterState state) =>
                      const NewTransaction())
            ]),
      ],
    ),

    // gateway
    GoRoute(
        name: 'Start',
        path: '/start',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => Start()),

    //
    // GoRoute(
    //     name: '',
    //     path: '',
    //     parentNavigatorKey: _rootNavigatorKey,
    //     builder: (BuildContext context, GoRouterState state) => const Gap(1)),

    // page
    // GoRoute(
    //     name: 'page',
    //     path: '/page',
    //     parentNavigatorKey: _rootNavigatorKey,
    //     builder: (BuildContext context, GoRouterState state) => SafeArea(
    //           child: SizedBox(
    //             width: double.infinity,
    //             height: double.infinity,
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Center(
    //                 child: CustomText(
    //                     text: "This will be the page",
    //                     style: TextStyle(
    //                         backgroundColor: Theme.of(context)
    //                             .colorScheme
    //                             .secondaryContainer)),
    //               ),
    //             ),
    //           ),
    //         ))
  ],
);

// Export the router instance
GoRouter get router => _router;
