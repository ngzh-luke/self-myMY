import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';
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
            buildQuickSettingsMenu(),
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

  Align buildQuickSettingsMenu() {
    return const Align(
      alignment: Alignment.topRight,
      child: QuickSettingsMenu(),
    );
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

  // Widget registerScreens(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Stack(
  //         clipBehavior: Clip.antiAlias,
  //         alignment: Alignment.bottomCenter,
  //         children: [
  //           SizedBox.square(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(15),
  //               child: PageView(
  //                   clipBehavior: Clip.antiAlias,
  //                   scrollDirection: Axis.horizontal,
  //                   controller: registerController,
  //                   children: [
  //                     _agreementScreen(context),
  //                     _regisFormScreen(context),
  //                   ]),
  //             ),
  //           ),
  //           Positioned(
  //             bottom: 3,
  //             child: Column(
  //               children: [
  //                 ElevatedButton(
  //                     // jump to login screen
  //                     onPressed: () {
  //                       rootController.previousPage(
  //                           duration: const Duration(seconds: 1),
  //                           curve: Curves.linearToEaseOut);
  //                     },
  //                     child: Text(
  //                       'Back to login',
  //                       style: TextStyle(
  //                           color: Theme.of(context).colorScheme.error),
  //                     )),
  //                 const Gap(8),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 15, bottom: 8.0),
  //                   child: SmoothPageIndicator(
  //                     controller: registerController,
  //                     axisDirection: Axis.horizontal,
  //                     count: 2,
  //                     effect: WormEffect(
  //                         spacing: 17,
  //                         paintStyle: PaintingStyle.stroke,
  //                         strokeWidth: 7,
  //                         dotColor: Theme.of(context).colorScheme.secondary,
  //                         activeDotColor:
  //                             Theme.of(context).colorScheme.onSecondary,
  //                         type: WormType.thinUnderground),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ]),
  //   );
  // }

  // Widget _agreementScreen(BuildContext context) {
  //   return Container(
  //     color: Theme.of(context).colorScheme.tertiaryContainer,
  //     child: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         children: [
  //           Text(AppLocalizations.of(context)!.heading_register,
  //               style: TextStyle(
  //                   color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                   fontSize:
  //                       Theme.of(context).textTheme.displayLarge!.fontSize)),
  //           const Gap(3),
  //           Text(
  //             "Agreements",
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.primary,
  //               fontSize: 26,
  //             ),
  //           ),
  //           _agreementFormInputsArea(context),
  //           const Gap.expand(10),
  //           Offstage(
  //             offstage: _hideContBtnCount == 3 ? false : true,
  //             child: MaterialButton(
  //               onPressed: () => registerController.nextPage(
  //                   duration: const Duration(seconds: 1),
  //                   curve: Curves.linearToEaseOut),
  //               clipBehavior: Clip.antiAlias,
  //               color: Theme.of(context).colorScheme.secondary,
  //               child: Text("Continue"),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Padding _agreementFormInputsArea(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ClipRRect(
  //       borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
  //       child: Container(
  //         padding: const EdgeInsets.all(10),
  //         color: Theme.of(context).colorScheme.onPrimaryContainer,
  //         child: ClipRRect(
  //           borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
  //           child: FormBuilder(
  //             key: _registerAgreementKey,
  //             autovalidateMode: AutovalidateMode.always,
  //             child: Column(
  //               children: [
  //                 FormBuilderCheckbox(
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _termsOfServiceChecked = value ?? false;
  //                       _termsOfServiceChecked == true
  //                           ? _hideContBtnCount++
  //                           : _hideContBtnCount;
  //                       _termsOfServiceChecked == false
  //                           ? _hideContBtnCount--
  //                           : _hideContBtnCount;
  //                     });
  //                     _registerAgreementKey.currentState?.saveAndValidate();
  //                     LogHelper.logger.i(value);
  //                   },

  //                   name: 'TermsOfService',
  //                   initialValue: _termsOfServiceChecked,
  //                   validator: FormBuilderValidators.equal(
  //                     true,
  //                     errorText: 'You must accept the Terms of Service',
  //                   ),
  //                   contentPadding: const EdgeInsets.symmetric(horizontal: 5),
  //                   subtitle: GestureDetector(
  //                       onTap: () {
  //                         LogHelper.logger.i("tab read terms");
  //                         context.read<NotificationManager>().showNotification(
  //                               context,
  //                               NotificationData(
  //                                   title: 'Info',
  //                                   message:
  //                                       'Simulate the display of the statement',
  //                                   type: CustomNotificationType.info),
  //                             );
  //                       },
  //                       child: const Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(Icons.info_outline),
  //                           Gap(3),
  //                           Text('Tap here to Read Terms of Service',
  //                               style: TextStyle(
  //                                   color: Colors.deepOrangeAccent,
  //                                   decoration: TextDecoration.underline)),
  //                         ],
  //                       )),
  //                   activeColor: Theme.of(context).colorScheme.primaryFixedDim,
  //                   // autovalidateMode: AutovalidateMode.onUserInteraction,
  //                   title: Text(
  //                     'You are agree to our Terms of Service',
  //                     style: TextStyle(
  //                         fontSize:
  //                             Theme.of(context).textTheme.bodySmall!.fontSize),
  //                   ),
  //                 ),
  //                 const Gap(2),
  //                 FormBuilderCheckbox(
  //                   name: 'PrivacyPolicy',
  //                   contentPadding: const EdgeInsets.symmetric(horizontal: 5),
  //                   initialValue: _privacyPolicyChecked,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _privacyPolicyChecked = value ?? false;
  //                       _privacyPolicyChecked == true
  //                           ? _hideContBtnCount++
  //                           : _hideContBtnCount;
  //                       _privacyPolicyChecked == false
  //                           ? _hideContBtnCount--
  //                           : _hideContBtnCount;
  //                     });
  //                     _registerAgreementKey.currentState?.saveAndValidate();
  //                     LogHelper.logger.i(value);
  //                   },
  //                   validator: FormBuilderValidators.equal(
  //                     true,
  //                     errorText: 'You must accept the Privacy Policy',
  //                   ),
  //                   subtitle: GestureDetector(
  //                     onTap: () {
  //                       LogHelper.logger.i("tab read privacy");
  //                       context.read<NotificationManager>().showNotification(
  //                             context,
  //                             NotificationData(
  //                                 title: 'Info',
  //                                 message:
  //                                     'Simulate the display of the statement',
  //                                 type: CustomNotificationType.info),
  //                           );
  //                     },
  //                     child: const Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Icon(Icons.info_outline),
  //                         Gap(3),
  //                         Text('Tap here to Read Privacy Policy',
  //                             style: TextStyle(
  //                                 color: Colors.deepOrangeAccent,
  //                                 decoration: TextDecoration.underline)),
  //                       ],
  //                     ),
  //                   ),

  //                   activeColor: Theme.of(context).colorScheme.primaryFixedDim,
  //                   // autovalidateMode: AutovalidateMode.onUserInteraction,
  //                   title: Text(
  //                     'You are agree to our Privacy Policy',
  //                     style: TextStyle(
  //                         fontSize:
  //                             Theme.of(context).textTheme.bodySmall!.fontSize),
  //                   ),
  //                 ),
  //                 const Gap(2),
  //                 FormBuilderCheckbox(
  //                   name: 'AgeAgreement',
  //                   contentPadding: const EdgeInsets.symmetric(horizontal: 5),
  //                   activeColor: Theme.of(context).colorScheme.primaryFixedDim,
  //                   initialValue: _ageAgreementChecked,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _ageAgreementChecked = value ?? false;
  //                       _ageAgreementChecked == true
  //                           ? _hideContBtnCount++
  //                           : _hideContBtnCount;
  //                       _ageAgreementChecked == false
  //                           ? _hideContBtnCount--
  //                           : _hideContBtnCount;
  //                     });
  //                     _registerAgreementKey.currentState?.saveAndValidate();
  //                     LogHelper.logger.i(value);
  //                   },
  //                   validator: FormBuilderValidators.equal(
  //                     true,
  //                     errorText: 'You must confirm your age',
  //                   ),
  //                   title: Text(
  //                     "You are hereby confirmed that you already obtained parent's approval to use the services and provide any data if you are under the age of 16",
  //                     style: TextStyle(
  //                         fontSize:
  //                             Theme.of(context).textTheme.bodySmall!.fontSize),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _regisFormScreen(BuildContext context) {
  //   Future<void> _register() async {
  //     try {
  //       await _auth.registerWithEmailAndPassword(
  //         _emailController.text.trim(),
  //         _passwordController.text,
  //       );
  //       Center(
  //         child: LoadingAnimationWidget.twoRotatingArc(
  //             color: Theme.of(context).colorScheme.onSurface, size: 20),
  //       );
  //       setState(() {
  //         context.read<NotificationManager>().showNotification(
  //               context,
  //               NotificationData(
  //                   title: 'Success',
  //                   message: 'Registration successful',
  //                   type: CustomNotificationType.success),
  //             );
  //         Future.delayed(Durations.short1);
  //         context.pushNamed("Start");
  //       });
  //     } on FirebaseAuthException catch (e) {
  //       setState(() {
  //         _errorMessage = _getReadableErrorMessage(e);
  //         context.read<NotificationManager>().showNotification(
  //               context,
  //               NotificationData(
  //                   title: 'Failed',
  //                   message: _errorMessage,
  //                   type: CustomNotificationType.error),
  //             );
  //       });
  //     } catch (e) {
  //       setState(() {
  //         _errorMessage = AppLocalizations.of(context)!.noti_errorOccurred;
  //       });
  //     }
  //   }

  //   return Container(
  //     color: Theme.of(context).colorScheme.tertiary,
  //     child: Padding(
  //       padding:
  //           const EdgeInsets.only(top: 25, bottom: 100, left: 10, right: 10),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(10),
  //         child: Container(
  //           // color: Theme.of(context).colorScheme.secondary,
  //           color: Colors.transparent,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(AppLocalizations.of(context)!.heading_register,
  //                   style: TextStyle(
  //                       color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                       fontSize: Theme.of(context)
  //                           .textTheme
  //                           .displayLarge!
  //                           .fontSize)),
  //               const Gap(3),
  //               Text(
  //                 "Account Creation",
  //                 style: TextStyle(
  //                   color: Theme.of(context).colorScheme.primary,
  //                   fontSize: 26,
  //                 ),
  //               ),
  //               _regisFormInputsArea(context),
  //               const Gap(7),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 15.0, right: 15),
  //                     child: MaterialButton(
  //                         clipBehavior: Clip.antiAliasWithSaveLayer,
  //                         color: Theme.of(context).colorScheme.primary,
  //                         child: Text("Submit"),
  //                         onPressed: () async {
  //                           // handle regist here
  //                           // TODO: localize these
  //                           if ((_termsOfServiceChecked == false) ||
  //                               (_privacyPolicyChecked == false) ||
  //                               (_ageAgreementChecked == false)) {
  //                             context
  //                                 .read<NotificationManager>()
  //                                 .showNotification(
  //                                   context,
  //                                   NotificationData(
  //                                       title: 'Error',
  //                                       message:
  //                                           "Account can't be created if you not agree to all the terms.",
  //                                       type: CustomNotificationType.error),
  //                                 );
  //                             registerController.jumpToPage(0);
  //                           } else if ((_registerFormKey.currentState
  //                                   ?.saveAndValidate() ==
  //                               true)) {
  //                             context.loaderOverlay.show();
  //                             await _register();
  //                             context.loaderOverlay.hide();
  //                           } else {
  //                             context
  //                                 .read<NotificationManager>()
  //                                 .showNotification(
  //                                   context,
  //                                   NotificationData(
  //                                       title: 'Error',
  //                                       message:
  //                                           'Please fill all fields correctly',
  //                                       type: CustomNotificationType.error),
  //                                 );
  //                           }
  //                         }),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Padding _regisFormInputsArea(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       child: Container(
  //         padding: const EdgeInsets.all(10),
  //         color: Theme.of(context).colorScheme.secondaryContainer,
  //         child: FormBuilder(
  //           key: _registerFormKey,
  //           child: Column(
  //             children: [
  //               FormBuilderTextField(
  //                 decoration: InputDecoration(
  //                     labelText: AppLocalizations.of(context)!.heading_email,
  //                     floatingLabelStyle: TextStyle(
  //                         color:
  //                             Theme.of(context).colorScheme.onSurfaceVariant)),
  //                 controller: _emailController,
  //                 name: 'email',
  //                 validator: FormBuilderValidators.email(),
  //                 autovalidateMode: AutovalidateMode.onUserInteraction,
  //               ),
  //               const Gap(20),
  //               FormBuilderTextField(
  //                   decoration: InputDecoration(labelText: 'Password'),
  //                   controller: _passwordController,
  //                   name: 'password',
  //                   obscureText: true,
  //                   obscuringCharacter: "*",
  //                   validator: FormBuilderValidators.password(),
  //                   autovalidateMode: AutovalidateMode.onUserInteraction),
  //               const Gap(5),
  //               FormBuilderTextField(
  //                 decoration:
  //                     InputDecoration(labelText: 'Confrim your Password'),
  //                 controller: _confirmPasswordController,
  //                 autovalidateMode: AutovalidateMode.onUserInteraction,
  //                 name: 'confirmPassword',
  //                 obscureText: true,
  //                 obscuringCharacter: "*",
  //                 validator: (value) {
  //                   if (value != _passwordController.text) {
  //                     return 'Passwords do not match';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
