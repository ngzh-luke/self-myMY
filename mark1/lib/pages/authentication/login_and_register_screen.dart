import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  LoginAndRegisterScreen({super.key});

  @override
  State<LoginAndRegisterScreen> createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  final rootController = PageController(initialPage: 0);

  final registerController = PageController(initialPage: 0);

  final AuthService _auth = AuthService();

  final _registerAgreementKey = GlobalKey<FormBuilderState>();

  final _registerFormKey = GlobalKey<FormBuilderState>();

  String _errorMessage = '';

  String _getReadableErrorMessage(FirebaseAuthException e) {
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
        return 'An error occurred. Please try again.';
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
                        registerScreen(context)
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
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    Future<void> _signIn() async {
      try {
        await _auth.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
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
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.heading_login,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize:
                      Theme.of(context).textTheme.displayLarge!.fontSize)),
          const Gap(1),
          ElevatedButton(
              // jump to register screen
              onPressed: () {
                rootController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInToLinear);
              },
              child: const CustomText(
                text: "Go to register screen",
              ))
        ],
      ),
    );
  }

  Widget registerScreen(BuildContext context) {
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
                  _agreementSection(context),
                  _regisFormSection(context),
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
                    child: const CustomText(
                      text: 'Go to login screen',
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

  Container _agreementSection(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
                child: FormBuilder(
                  key: _registerAgreementKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      FormBuilderCheckbox(
                        onChanged: (value) {
                          _registerAgreementKey.currentState?.saveAndValidate();
                          LogHelper.logger.i(value);
                        },

                        name: 'TermsOfService',
                        validator: FormBuilderValidators.isTrue(),

                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        subtitle: GestureDetector(
                            onTap: () {
                              LogHelper.logger.i("tab read terms");
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
                        activeColor:
                            Theme.of(context).colorScheme.primaryFixedDim,
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        onChanged: (value) {
                          _registerAgreementKey.currentState?.saveAndValidate();
                          LogHelper.logger.i(value);
                        },
                        subtitle: GestureDetector(
                          onTap: () {
                            LogHelper.logger.i("tab read privacy");
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
                        validator: FormBuilderValidators.isTrue(),

                        activeColor:
                            Theme.of(context).colorScheme.primaryFixedDim,
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
                        validator: FormBuilderValidators.isTrue(),
                        onChanged: (value) {
                          _registerAgreementKey.currentState?.saveAndValidate();
                          LogHelper.logger.i(value);
                        },
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        activeColor:
                            Theme.of(context).colorScheme.primaryFixedDim,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
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
            const Gap.expand(10),
          ],
        ),
      ),
    );
  }

  Widget _regisFormSection(BuildContext context) {
    TextEditingController _passwordCon = TextEditingController();
    TextEditingController _passwordCon2 = TextEditingController();
    TextEditingController _email = TextEditingController();

    Future<void> _register() async {
      try {
        await _auth.registerWithEmailAndPassword(
          _email.text,
          _passwordCon.text,
        );
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
          _errorMessage = 'An unexpected error occurred. Please try again.';
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
                Padding(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),
                              controller: _email,
                              name: 'email',
                              validator: FormBuilderValidators.email(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const Gap(20),
                            FormBuilderTextField(
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                controller: _passwordCon,
                                name: 'password',
                                obscureText: true,
                                obscuringCharacter: "*",
                                validator: FormBuilderValidators.password(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction),
                            const Gap(5),
                            FormBuilderTextField(
                              decoration: const InputDecoration(
                                  labelText: 'Confrim your Password'),
                              controller: _passwordCon2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: 'confirmPassword',
                              obscureText: true,
                              obscuringCharacter: "*",
                              validator: FormBuilderValidators.required(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(7),
                MaterialButton(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Theme.of(context).colorScheme.primary,
                    child: Text("Submit"),
                    onPressed: () async {
                      // handle regist here
                      _registerAgreementKey.currentState?.saveAndValidate();
                      _registerFormKey.currentState?.saveAndValidate();
                      await _register();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
