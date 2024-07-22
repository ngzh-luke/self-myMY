import 'package:flutter/material.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginAndRegisterScreen extends StatelessWidget {
  LoginAndRegisterScreen({super.key});

  final rootController = PageController(initialPage: 0);
  final registerController = PageController(initialPage: 0);
  final AuthService _auth = AuthService();
  final _registerFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 700,
                child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: rootController,
                    children: [loginScreen(context), registerScreen(context)]),
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
    );
  }

  Widget loginScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CustomText(
            style: Theme.of(context).textTheme.displayLarge,
            text: AppLocalizations.of(context)!.heading_login,
          ),
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
            Text(
              style: Theme.of(context).textTheme.displayLarge,
              AppLocalizations.of(context)!.heading_register,
            ),
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
              child: FormBuilder(
                key: _registerFormKey,
                child: Column(
                  children: [
                    FormBuilderSwitch(
                      name: 'TermsOfService',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      subtitle: GestureDetector(
                          onTap: () {
                            print("tab terms");
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
                      activeColor: Colors.tealAccent,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      title: const Text(
                        'You are agree to our Terms of Service',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    const Gap(2),
                    FormBuilderSwitch(
                      name: 'PrivacyPolicy',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      subtitle: GestureDetector(
                          onTap: () {
                            print("tab privacy");
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
                          )),
                      activeColor: Colors.tealAccent,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      title: const Text(
                        'You are agree to our Privacy Policy',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    const Gap(2),
                    FormBuilderSwitch(
                      name: 'AgeAgreement',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      activeColor: Colors.tealAccent,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      title: const Text(
                        "You are hereby confirmed that you already obtained parent's approval to use the services and provide any data if you are under the age of 16",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
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
                Text(
                  AppLocalizations.of(context)!.heading_register,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const Gap(3),
                Text(
                  "Account Creation",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
