import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymy_m1/pages/authentication/login_and_register_screen.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';

class Start extends StatelessWidget {
  Start({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CustomText(
                text: 'Something has went wrong, please try again later'),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginAndRegisterScreen();
          } else {
            context.goNamed('Home');
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
