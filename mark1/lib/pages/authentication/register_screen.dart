import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mymy_m1/helpers/logs/log_helper.dart';
import 'package:mymy_m1/l10n/app_localization_consts.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/shared/ui_consts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget registerScreens(
  BuildContext context, {
  required PageController registerController,
  required PageController rootController,
  required int hideContBtnCount,
  required GlobalKey<FormBuilderState> registerFormKey,
  required GlobalKey<FormBuilderState> registerAgreementKey,
  required Future<void> Function() register,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required bool privacyPolicyChecked,
  required bool ageAgreementChecked,
  required bool termsOfServiceChecked,
  required Function(String, bool) onCheckboxChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
    child: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.square(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: PageView(
                  clipBehavior: Clip.antiAlias,
                  scrollDirection: Axis.horizontal,
                  controller: registerController,
                  children: [
                    AgreementScreen(
                      registerController: registerController,
                      registerAgreementKey: registerAgreementKey,
                      termsOfServiceChecked: termsOfServiceChecked,
                      privacyPolicyChecked: privacyPolicyChecked,
                      ageAgreementChecked: ageAgreementChecked,
                      onCheckboxChanged: onCheckboxChanged,
                    ),
                    SingleChildScrollView(
                      child: _regisFormScreen(
                        context,
                        registerController: registerController,
                        registerFormKey: registerFormKey,
                        register: () => register(),
                        termsOfServiceChecked: termsOfServiceChecked,
                        privacyPolicyChecked: privacyPolicyChecked,
                        ageAgreementChecked: ageAgreementChecked,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                      ),
                    ),
                  ]),
            ),
          ),
          Positioned(
            bottom: 3,
            child: Column(
              children: [
                ElevatedButton(
                    // jump to login screen
                    onPressed: () {
                      rootController.previousPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.linearToEaseOut);
                    },
                    child: Text(
                      'Back to login',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    )),
                UiConsts.spaceBetweenSections,
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                  child: SmoothPageIndicator(
                    controller: registerController,
                    axisDirection: Axis.horizontal,
                    count: 2,
                    effect: WormEffect(
                        spacing: 17,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 7,
                        dotColor: Theme.of(context).colorScheme.secondary,
                        activeDotColor:
                            Theme.of(context).colorScheme.onSecondary,
                        type: WormType.thinUnderground),
                  ),
                ),
              ],
            ),
          )
        ]),
  );
}

class AgreementScreen extends StatelessWidget {
  final PageController registerController;
  final GlobalKey<FormBuilderState> registerAgreementKey;
  final bool termsOfServiceChecked;
  final bool privacyPolicyChecked;
  final bool ageAgreementChecked;
  final Function(String, bool) onCheckboxChanged;

  const AgreementScreen({
    Key? key,
    required this.registerController,
    required this.registerAgreementKey,
    required this.termsOfServiceChecked,
    required this.privacyPolicyChecked,
    required this.ageAgreementChecked,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hideContBtnCount = [
      termsOfServiceChecked,
      privacyPolicyChecked,
      ageAgreementChecked
    ].where((checked) => checked).length;

    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.heading_register,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize)),
            UiConsts.spaceBetweenElementsInTheSection,
            Text(
              "Agreements",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 26,
              ),
            ),
            _agreementFormInputsArea(context),
            UiConsts.spaceBetweenSections,
            Offstage(
              offstage: hideContBtnCount != 3,
              child: MaterialButton(
                onPressed: () => registerController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Continue"),
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
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.elliptical(15, 20)),
            child: FormBuilder(
              key: registerAgreementKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  _buildCheckbox(
                    context,
                    'TermsOfService',
                    'You agree to our Terms of Service',
                    termsOfServiceChecked,
                    (value) => onCheckboxChanged(
                        'termsOfServiceChecked', value ?? false),
                  ),
                  UiConsts.spaceBetweenElementsInTheSection,
                  _buildCheckbox(
                    context,
                    'PrivacyPolicy',
                    'You agree to our Privacy Policy',
                    privacyPolicyChecked,
                    (value) => onCheckboxChanged(
                        'privacyPolicyChecked', value ?? false),
                  ),
                  UiConsts.spaceBetweenElementsInTheSection,
                  _buildCheckbox(
                    context,
                    'AgeAgreement',
                    "You confirm that you have obtained parent's approval to use the services if you are under the age of 16",
                    ageAgreementChecked,
                    (value) => onCheckboxChanged(
                        'ageAgreementChecked', value ?? false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormBuilderCheckbox _buildCheckbox(
    BuildContext context,
    String name,
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return FormBuilderCheckbox(
      name: name,
      initialValue: value,
      onChanged: onChanged,
      validator: FormBuilderValidators.equal(
        true,
        errorText: 'You must accept this agreement',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        title,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
      ),
      subtitle: GestureDetector(
        onTap: () {
          LogHelper.logger.i("tab read terms $name");
          context.read<NotificationManager>().showNotification(
                context,
                NotificationData(
                    title: 'Info',
                    message: 'Simulate the display of the statement',
                    type: CustomNotificationType.info),
              );
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline),
            UiConsts.spaceBetweenElementsInTheSection,
            Text('Tap here to Read Terms of Service',
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    decoration: TextDecoration.underline)),
          ],
        ),
      ),
      activeColor: Theme.of(context).colorScheme.primaryFixedDim,
    );
  }
}

Widget _regisFormScreen(
  BuildContext context, {
  required PageController registerController,
  required GlobalKey<FormBuilderState> registerFormKey,
  required bool termsOfServiceChecked,
  required Future<void> Function() register,
  required TextEditingController passwordController,
  required bool privacyPolicyChecked,
  required bool ageAgreementChecked,
  required TextEditingController emailController,
  required TextEditingController confirmPasswordController,
}) {
  return Container(
    color: Theme.of(context).colorScheme.tertiary,
    child: Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 100, left: 10, right: 10),
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
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize:
                          Theme.of(context).textTheme.displayLarge!.fontSize)),
              UiConsts.spaceBetweenElementsInTheSection,
              Text(
                "Account Creation",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 26,
                ),
              ),
              _regisFormInputsArea(context,
                  registerFormKey: registerFormKey,
                  confirmPasswordController: confirmPasswordController,
                  passwordController: passwordController,
                  emailController: emailController),
              UiConsts.spaceBetweenElementsInTheSectionLarge,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: MaterialButton(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Theme.of(context).colorScheme.primary,
                        child: Text("Submit"),
                        onPressed: () async {
                          // handle regist here
                          // TODO: localize these
                          if ((termsOfServiceChecked == false) ||
                              (privacyPolicyChecked == false) ||
                              (ageAgreementChecked == false)) {
                            context
                                .read<NotificationManager>()
                                .showNotification(
                                  context,
                                  NotificationData(
                                      title: 'Error',
                                      message:
                                          "Account can't be created if you not agree to all the terms.",
                                      type: CustomNotificationType.error),
                                );
                            registerController.jumpToPage(0);
                          } else if ((registerFormKey.currentState
                                  ?.saveAndValidate() ==
                              true)) {
                            context.loaderOverlay.show();
                            await register();
                            context.loaderOverlay.hide();
                          } else {
                            context
                                .read<NotificationManager>()
                                .showNotification(
                                  context,
                                  NotificationData(
                                      title: 'Error',
                                      message:
                                          'Please fill all fields correctly',
                                      type: CustomNotificationType.error),
                                );
                          }
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Padding _regisFormInputsArea(BuildContext context,
    {required GlobalKey<FormBuilderState> registerFormKey,
    required TextEditingController confirmPasswordController,
    required TextEditingController passwordController,
    required TextEditingController emailController}) {
  return Padding(
    padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: FormBuilder(
          key: registerFormKey,
          child: Column(
            children: [
              FormBuilderTextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.heading_email,
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                controller: emailController,
                name: 'email',
                validator: FormBuilderValidators.email(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              UiConsts.spaceBetweenSectionsLarge,
              FormBuilderTextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: passwordController,
                  name: 'password',
                  obscureText: true,
                  obscuringCharacter: "*",
                  validator: FormBuilderValidators.password(),
                  autovalidateMode: AutovalidateMode.onUserInteraction),
              UiConsts.spaceBetweenSectionsLarge,
              FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Confrim your Password'),
                controller: confirmPasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                name: 'confirmPassword',
                obscureText: true,
                obscuringCharacter: "*",
                validator: (value) {
                  if (value != passwordController.text) {
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
