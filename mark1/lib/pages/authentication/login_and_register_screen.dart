// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mymy_m1/helpers/logs/log_helper.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginAndRegisterScreen extends StatefulWidget {
  const LoginAndRegisterScreen({super.key});

  @override
  State<LoginAndRegisterScreen> createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  final rootController = PageController(initialPage: 0);
  final registerController = PageController(initialPage: 0);

  final AuthService _auth = AuthService();

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

  var _hideContBtnCount = 0;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 700,
                  child: PageView(
                      scrollDirection: Axis.vertical,
                      controller: rootController,
                      children: [
                        loginScreen(context),
                        registerScreens(context)
                      ]),
                ),
              ),
              SmoothPageIndicator(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginScreen(BuildContext context) {
    Future<void> _signIn() async {
      try {
        await _auth.signInWithEmailAndPassword(
          _loginEmailController.text,
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.heading_login,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize:
                          Theme.of(context).textTheme.displayLarge!.fontSize)),
              _loginFormInputsArea(context),
              const Gap(7),
              MaterialButton(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text("Submit"),
                  onPressed: () async {
                    // handle login here
                    if ((_loginEmailController.text.isEmpty == false) &&
                        (_loginPasswordController.text.isEmpty == false) &&
                        (_loginFormKey.currentState?.saveAndValidate() ==
                            true)) {
                      await _signIn();
                    } else {
                      _loginFormKey.currentState?.saveAndValidate();
                      context.read<NotificationManager>().showNotification(
                            context,
                            NotificationData(
                                title: 'Error',
                                message: 'Please fill all fields correctly',
                                type: CustomNotificationType.error),
                          );
                    }
                  }),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Don't have account yet?",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            Gap(3),
            ElevatedButton(
                // jump to register screen
                onPressed: () {
                  rootController.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInToLinear);
                },
                child: CustomText(
                  text: "Register now!",
                )),
            Gap(10)
          ],
        ),
      ],
    );
  }

  Widget _loginFormInputsArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: FormBuilder(
                key: _loginFormKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          floatingLabelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      controller: _loginEmailController,
                      name: 'email',
                      validator: FormBuilderValidators.email(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const Gap(20),
                    FormBuilderTextField(
                        decoration: InputDecoration(labelText: 'Password'),
                        controller: _loginPasswordController,
                        name: 'password',
                        obscureText: true,
                        obscuringCharacter: "*",
                        validator: FormBuilderValidators.required(),
                        autovalidateMode: AutovalidateMode.onUserInteraction),
                    const Gap(5),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: MaterialButton(
              color: Theme.of(context).hoverColor,
              child: Text("Forgot password?"),
              // TODO: to password retrieval page
              onPressed: () => context
                  .read<NotificationManager>()
                  .showNotification(
                      context,
                      NotificationData(
                          title: 'Info',
                          message: "Simulate to forget password page",
                          type: CustomNotificationType.warning))),
        ),
      ],
    );
  }

  Widget registerScreens(BuildContext context) {
    return Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView(
                clipBehavior: Clip.antiAlias,
                scrollDirection: Axis.horizontal,
                controller: registerController,
                children: [
                  _agreementScreen(context),
                  _regisFormScreen(context),
                ]),
          ),
          Positioned(
            bottom: 5,
            child: Column(
              children: [
                ElevatedButton(
                    // jump to login screen
                    onPressed: () {
                      rootController.previousPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.linearToEaseOut);
                    },
                    child: CustomText(
                      text: 'Back to login',
                    )),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 12.0),
                  child: SmoothPageIndicator(
                    controller: registerController,
                    axisDirection: Axis.horizontal,
                    count: 2,
                    effect: WormEffect(
                        spacing: 17,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 7,
                        dotColor:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        activeDotColor:
                            Theme.of(context).colorScheme.onSecondary,
                        type: WormType.thinUnderground),
                  ),
                ),
              ],
            ),
          )
        ]);
  }

  Container _agreementScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.heading_register,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize)),
            const Gap(3),
            Text(
              "Agreements",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 26,
              ),
            ),
            _agreementFormInputsArea(context),
            const Gap.expand(10),
            Offstage(
              offstage: _hideContBtnCount == 3 ? false : true,
              child: MaterialButton(
                onPressed: () => registerController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.linearToEaseOut),
                child: Text("Continue"),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _agreementFormInputsArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
            child: FormBuilder(
              key: _registerAgreementKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  FormBuilderCheckbox(
                    onChanged: (value) {
                      setState(() {
                        _termsOfServiceChecked = value ?? false;
                        _termsOfServiceChecked == true
                            ? _hideContBtnCount++
                            : _hideContBtnCount;
                        _termsOfServiceChecked == false
                            ? _hideContBtnCount--
                            : _hideContBtnCount;
                      });
                      _registerAgreementKey.currentState?.saveAndValidate();
                      LogHelper.logger.i(value);
                    },

                    name: 'TermsOfService',
                    initialValue: _termsOfServiceChecked,
                    validator: FormBuilderValidators.equal(
                      true,
                      errorText: 'You must accept the Terms of Service',
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    subtitle: GestureDetector(
                        onTap: () {
                          LogHelper.logger.i("tab read terms");
                          context.read<NotificationManager>().showNotification(
                                context,
                                NotificationData(
                                    title: 'Info',
                                    message:
                                        'Simulate the display of the statement',
                                    type: CustomNotificationType.info),
                              );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline),
                            Gap(3),
                            Text('Tap here to Read Terms of Service',
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    decoration: TextDecoration.underline)),
                          ],
                        )),
                    activeColor: Theme.of(context).colorScheme.primaryFixedDim,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    title: Text(
                      'You are agree to our Terms of Service',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .fontSize),
                    ),
                  ),
                  const Gap(2),
                  FormBuilderCheckbox(
                    name: 'PrivacyPolicy',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    initialValue: _privacyPolicyChecked,
                    onChanged: (value) {
                      setState(() {
                        _privacyPolicyChecked = value ?? false;
                        _privacyPolicyChecked == true
                            ? _hideContBtnCount++
                            : _hideContBtnCount;
                        _privacyPolicyChecked == false
                            ? _hideContBtnCount--
                            : _hideContBtnCount;
                      });
                      _registerAgreementKey.currentState?.saveAndValidate();
                      LogHelper.logger.i(value);
                    },
                    validator: FormBuilderValidators.equal(
                      true,
                      errorText: 'You must accept the Privacy Policy',
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        LogHelper.logger.i("tab read privacy");
                        context.read<NotificationManager>().showNotification(
                              context,
                              NotificationData(
                                  title: 'Info',
                                  message:
                                      'Simulate the display of the statement',
                                  type: CustomNotificationType.info),
                            );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline),
                          Gap(3),
                          Text('Tap here to Read Privacy Policy',
                              style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),

                    activeColor: Theme.of(context).colorScheme.primaryFixedDim,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    title: Text(
                      'You are agree to our Privacy Policy',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .fontSize),
                    ),
                  ),
                  const Gap(2),
                  FormBuilderCheckbox(
                    name: 'AgeAgreement',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    activeColor: Theme.of(context).colorScheme.primaryFixedDim,
                    initialValue: _ageAgreementChecked,
                    onChanged: (value) {
                      setState(() {
                        _ageAgreementChecked = value ?? false;
                        _ageAgreementChecked == true
                            ? _hideContBtnCount++
                            : _hideContBtnCount;
                        _ageAgreementChecked == false
                            ? _hideContBtnCount--
                            : _hideContBtnCount;
                      });
                      _registerAgreementKey.currentState?.saveAndValidate();
                      LogHelper.logger.i(value);
                    },
                    validator: FormBuilderValidators.equal(
                      true,
                      errorText: 'You must confirm your age',
                    ),
                    title: Text(
                      "You are hereby confirmed that you already obtained parent's approval to use the services and provide any data if you are under the age of 16",
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .fontSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _regisFormScreen(BuildContext context) {
    Future<void> _register() async {
      try {
        await _auth.registerWithEmailAndPassword(
          _emailController.text,
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
          context.goNamed("Start");
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

    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, bottom: 100, left: 10, right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // color: Theme.of(context).colorScheme.secondary,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.heading_register,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .fontSize)),
                const Gap(3),
                Text(
                  "Account Creation",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 26,
                  ),
                ),
                _regisFormInputsArea(context),
                const Gap(7),
                MaterialButton(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Theme.of(context).colorScheme.primary,
                    child: Text("Submit"),
                    onPressed: () async {
                      // handle regist here
                      // TODO: localize these
                      if ((_termsOfServiceChecked == false) ||
                          (_privacyPolicyChecked == false) ||
                          (_ageAgreementChecked == false)) {
                        context.read<NotificationManager>().showNotification(
                              context,
                              NotificationData(
                                  title: 'Error',
                                  message:
                                      "Account can't be created if you not agree to all the terms.",
                                  type: CustomNotificationType.error),
                            );
                        registerController.jumpToPage(0);
                      } else if ((_registerFormKey.currentState
                              ?.saveAndValidate() ==
                          true)) {
                        await _register();
                      } else {
                        context.read<NotificationManager>().showNotification(
                              context,
                              NotificationData(
                                  title: 'Error',
                                  message: 'Please fill all fields correctly',
                                  type: CustomNotificationType.error),
                            );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _regisFormInputsArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: FormBuilder(
            key: _registerFormKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelStyle: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  controller: _emailController,
                  name: 'email',
                  validator: FormBuilderValidators.email(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Gap(20),
                FormBuilderTextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    name: 'password',
                    obscureText: true,
                    obscuringCharacter: "*",
                    validator: FormBuilderValidators.password(),
                    autovalidateMode: AutovalidateMode.onUserInteraction),
                const Gap(5),
                FormBuilderTextField(
                  decoration:
                      InputDecoration(labelText: 'Confrim your Password'),
                  controller: _confirmPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'confirmPassword',
                  obscureText: true,
                  obscuringCharacter: "*",
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
