import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';

Widget loginScreen(BuildContext context,
    {required AuthService auth,
    required Future<void> Function() signIn,
    required GlobalKey<FormBuilderState> loginFormKey,
    required TextEditingController loginEmailController,
    required TextEditingController loginPasswordController,
    required PageController rootController}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(AppLocalizations.of(context)!.heading_login,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize:
                          Theme.of(context).textTheme.displayLarge!.fontSize)),
            ),
            _loginFormInputsArea(
              context,
              loginFormKey: loginFormKey,
              loginEmailController: loginEmailController,
              loginPasswordController: loginPasswordController,
            ),
            const Gap(7),
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
      _jumpToRegisScreenBtn(context, rootController: rootController),
    ],
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
                  const Gap(20),
                  FormBuilderTextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: loginPasswordController,
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
            child: Text("Reset password"),
            // TODO: to password retrieval page
            onPressed: () => context.pushNamed("ResetPasswordPage")
            // context
            //     .read<NotificationManager>()
            //     .showNotification(
            //         context,
            //         NotificationData(
            //             title: 'Info',
            //             message: "Simulate to forget password page",
            //             type: CustomNotificationType.warning))
            ),
      ),
    ],
  );
}

Column _jumpToRegisScreenBtn(BuildContext context,
    {required PageController rootController}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Don't have account yet?",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      const Gap(3),
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
      const Gap(10)
    ],
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
