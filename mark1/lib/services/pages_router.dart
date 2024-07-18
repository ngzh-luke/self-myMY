import 'package:go_router/go_router.dart';
import 'package:mymy_m1/pages/home.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(title: "myMY M1"),
    ),
  ],
);

// Export the router instance
GoRouter get router => _router;
