import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/shared/ui_consts.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthService _auth = getIt<AuthService>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return mainView(
      context,
      appBarTitle: AppLocalizations.of(context)!.heading_resetPassword,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.reset_password_instruction,
              textAlign: TextAlign.center,
            ),
            UiConsts.spaceBetweenSectionsLarge,
            _buildForm(),
            UiConsts.spaceBetweenSectionsLarge,
            _buildSubmitButton(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UiConsts.spaceBetweenSections,
                _buildBackToLoginButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.heading_email,
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(AppLocalizations.of(context)!.heading_submit),
    );
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () => context.pop(),
      child: Text(AppLocalizations.of(context)!.heading_back),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final email = _formKey.currentState!.fields['email']!.value as String;
        await _auth.resetPassword(email.trim());

        _showSuccessNotification();
        context.goNamed("Start");
      } on FirebaseAuthException catch (e) {
        _showErrorNotification(
            e.message ?? AppLocalizations.of(context)!.noti_errorOccurred);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessNotification() {
    context.read<NotificationManager>().showNotification(
          context,
          NotificationData(
            title: AppLocalizations.of(context)!.heading_success,
            message: AppLocalizations.of(context)!.resetPasswordEmailSent,
            type: CustomNotificationType.success,
          ),
        );
  }

  void _showErrorNotification(String message) {
    context.read<NotificationManager>().showNotification(
          context,
          NotificationData(
            title: AppLocalizations.of(context)!.noti_errorOccurred,
            message: message,
            type: CustomNotificationType.error,
          ),
        );
  }
}
