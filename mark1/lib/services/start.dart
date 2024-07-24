import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymy_m1/helpers/logs/log_helper.dart';
import 'package:mymy_m1/pages/authentication/login_and_register_screen.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:mymy_m1/services/authentication/user_session.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';

class Start extends StatelessWidget {
  Start({super.key});

  final AuthService _auth = getIt<AuthService>();
  final UserSession _userSession = getIt<UserSession>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginAndRegisterScreen();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                context.goNamed("Home");
              } catch (e) {
                LogHelper.logger.d('-Navigation error: $e');
              }
            });
            return const SizedBox.shrink();
          }
        }
        return Scaffold(
            body: Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                    color: Theme.of(context).colorScheme.onSurface, size: 20)));
      },
    );
  }
}
