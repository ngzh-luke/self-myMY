import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';
import 'package:mymy_m1/on_page_tips/login_screen_tips.dart';
import 'package:mymy_m1/pages/authentication/register_screen.dart';
import 'package:mymy_m1/pages/settings/quick_settings_menu.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mymy_m1/pages/authentication/login_screen.dart';

class LoginAndRegisterScreen extends StatefulWidget {
  const LoginAndRegisterScreen({super.key});

  @override
  State<LoginAndRegisterScreen> createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  final rootController = PageController(initialPage: 0);
  final registerController = PageController(initialPage: 0);

  final AuthService _auth = getIt<AuthService>();

  final _loginFormKey = GlobalKey<FormBuilderState>();
  final _registerAgreementKey = GlobalKey<FormBuilderState>();
  final _registerFormKey = GlobalKey<FormBuilderState>();

  bool _termsOfServiceChecked = false;
  bool _privacyPolicyChecked = false;
  bool _ageAgreementChecked = false;

  String _errorMessage = '';

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ignore: prefer_final_fields
  int _hideContBtnCount = 0;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    rootController.dispose();
    registerController.dispose();
    super.dispose();
  }

  String _getReadableErrorMessage(FirebaseAuthException e) {
    // TODO: localize these
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return '${AppLocalizations.of(context)!.noti_errorOccurred} Details: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildRootAuthViewer(context);
  }

  Scaffold buildRootAuthViewer(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildQuickSettingsMenuAndPageTips(),
            buildMainAuthScreens(context),
            buildMainAuthScreensIndicator(context),
          ],
        ),
      ),
    );
  }

  SmoothPageIndicator buildMainAuthScreensIndicator(BuildContext context) {
    return SmoothPageIndicator(
      controller: rootController,
      axisDirection: Axis.vertical,
      count: 2,
      effect: SwapEffect(
          spacing: 10,
          dotHeight: 15,
          dotWidth: 22,
          radius: 0,
          type: SwapType.zRotation,
          activeDotColor: Theme.of(context).colorScheme.primary),
    );
  }

  Expanded buildMainAuthScreens(BuildContext context) {
    return Expanded(
      child: PageView(
          scrollDirection: Axis.vertical,
          controller: rootController,
          children: [
            loginScreen(
              context,
              loginFormKey: _loginFormKey,
              loginEmailController: _loginEmailController,
              loginPasswordController: _loginPasswordController,
              rootController: rootController,
              auth: _auth,
              signIn: () => _signIn(),
            ),
            registerScreens(context,
                registerController: registerController,
                rootController: rootController,
                registerFormKey: _registerFormKey,
                registerAgreementKey: _registerAgreementKey,
                register: () => _register(),
                hideContBtnCount: _hideContBtnCount,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                privacyPolicyChecked: _privacyPolicyChecked,
                ageAgreementChecked: _ageAgreementChecked,
                termsOfServiceChecked: _termsOfServiceChecked,
                onCheckboxChanged: (String name, bool value) {
                  setState(() {
                    switch (name) {
                      case 'termsOfServiceChecked':
                        _termsOfServiceChecked = value;
                        break;
                      case 'privacyPolicyChecked':
                        _privacyPolicyChecked = value;
                        break;
                      case 'ageAgreementChecked':
                        _ageAgreementChecked = value;
                        break;
                    }
                  });
                })
          ]),
    );
  }

  Widget buildQuickSettingsMenuAndPageTips() {
    // return const Align(
    //   alignment: Alignment.topLeft,
    //   child: QuickSettingsMenu(),
    // );
    return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickSettingsMenu(),
          LoginScreenTips(),
        ]);
  }

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        _loginEmailController.text.trim(),
        _loginPasswordController.text,
      );
      Center(
        child: LoadingAnimationWidget.twoRotatingArc(
            color: Theme.of(context).colorScheme.onSurface, size: 20),
      );
      setState(() {
        Center(
          child: LoadingAnimationWidget.twoRotatingArc(
              color: Theme.of(context).colorScheme.onSurface, size: 20),
        );
        context.read<NotificationManager>().showNotification(
              context,
              NotificationData(
                  title: 'Success',
                  message: "Welcome back",
                  type: CustomNotificationType.success),
            );
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getReadableErrorMessage(e);
        context.read<NotificationManager>().showNotification(
              context,
              NotificationData(
                  title: 'Failed',
                  message: _errorMessage,
                  type: CustomNotificationType.error),
            );
      });
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.noti_errorOccurred;
      });
    }
  }

  Future<void> _register() async {
    try {
      await _auth.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      Center(
        child: LoadingAnimationWidget.twoRotatingArc(
            color: Theme.of(context).colorScheme.onSurface, size: 20),
      );
      setState(() {
        context.read<NotificationManager>().showNotification(
              context,
              NotificationData(
                  title: 'Success',
                  message: 'Registration successful',
                  type: CustomNotificationType.success),
            );
        Future.delayed(Durations.short1);
        context.pushNamed("Start");
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getReadableErrorMessage(e);
        context.read<NotificationManager>().showNotification(
              context,
              NotificationData(
                  title: 'Failed',
                  message: _errorMessage,
                  type: CustomNotificationType.error),
            );
      });
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.noti_errorOccurred;
      });
    }
  }
}
