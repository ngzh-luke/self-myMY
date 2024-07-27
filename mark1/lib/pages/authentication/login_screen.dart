import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/shared/ui_consts.dart';
import 'package:provider/provider.dart';

Widget loginScreen(BuildContext context,
    {required AuthService auth,
    required Future<void> Function() signIn,
    required GlobalKey<FormBuilderState> loginFormKey,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController,
    required PageController rootController}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(AppLocalizations.of(context)!.heading_login,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .fontSize)),
              ),
              _loginFormInputsArea(
                context,
                loginFormKey: loginFormKey,
                loginEmailController: loginEmailController,
                loginPasswordController: loginPasswordController,
              ),
              UiConsts.spaceBetweenSections,
              _loginFormSubmitBtn(
                context,
                signIn: () => signIn(),
                loginEmailController: loginEmailController,
                loginPasswordController: loginPasswordController,
                loginFormKey: loginFormKey,
              ),
            ],
          ),
        ),
        UiConsts.spaceBetweenSectionsLarge,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.7,
              )),
              // TODO: localize
              Text(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  " " + 'OR CONTINUE WITH' + " "),
              Expanded(
                  child: Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.7,
              ))
            ],
          ),
        ),
        UiConsts.spaceBetweenSections,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                color: Colors.white,
                onPressed: () {
                  context.read<NotificationManager>().showNotification(
                      context,
                      NotificationData(
                          title: "Feature unavailable",
                          message: "Under development",
                          type: CustomNotificationType.warning));
                },
                child: const Icon(
                  BoxIcons.bxl_apple,
                  size: UiConsts.largeIconSize,
                )),
            UiConsts.spaceBetweenElementsInTheSectionLarge,
            MaterialButton(
              color: Colors.white,
              onPressed: () async => await auth.continueWithGoogle(),
              child: const Icon(
                BoxIcons.bxl_google,
                color: Colors.black,
                size: UiConsts.largeIconSize,
              ),
            ),
          ],
        ),
        UiConsts.spaceBetweenSectionsLarge,
        _jumpToRegisScreenBtn(context, rootController: rootController),
      ],
    ),
  );
}

Widget _loginFormInputsArea(BuildContext context,
    {required GlobalKey<FormBuilderState> loginFormKey,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
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
              key: loginFormKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.heading_email,
                        floatingLabelStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    controller: loginEmailController,
                    name: 'email',
                    validator: FormBuilderValidators.email(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  UiConsts.spaceBetweenElementsInTheSectionLarge,
                  FormBuilderTextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: loginPasswordController,
                      name: 'password',
                      obscureText: true,
                      obscuringCharacter: "*",
                      validator: FormBuilderValidators.required(),
                      autovalidateMode: AutovalidateMode.onUserInteraction),
                  UiConsts.spaceBetweenElementsInTheSectionMedium,
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
            child: Text(AppLocalizations.of(context)!.heading_resetPassword),
            onPressed: () => context.pushNamed("ResetPasswordPage")),
      ),
    ],
  );
}

Widget _jumpToRegisScreenBtn(BuildContext context,
    {required PageController rootController}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Don't have account yet?",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        UiConsts.spaceForTextAndElement,
        ElevatedButton(
            // jump to register screen
            onPressed: () {
              rootController.nextPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInToLinear);
            },
            child: Text(
              "Register now!",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )),
      ],
    ),
  );
}

Column _loginFormSubmitBtn(BuildContext context,
    {required Future<void> Function() signIn,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController,
    required GlobalKey<FormBuilderState> loginFormKey}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5),
        child: MaterialButton(
            height: UiConsts.largeMaterialBtnHeight,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Theme.of(context).colorScheme.primary,
            child: Text(AppLocalizations.of(context)!.heading_submit),
            onPressed: () async {
              // handle login here
              if ((loginEmailController.text.isEmpty == false) &&
                  (loginPasswordController.text.isEmpty == false) &&
                  (loginFormKey.currentState?.saveAndValidate() == true)) {
                context.loaderOverlay.show();
                await signIn();
                context.loaderOverlay.hide();
              } else {
                loginFormKey.currentState?.saveAndValidate();
                context.read<NotificationManager>().showNotification(
                      context,
                      NotificationData(
                          title: 'Error',
                          message: 'Please fill all fields correctly',
                          type: CustomNotificationType.error),
                    );
              }
            }),
      ),
    ],
  );
}
