import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

enum DialogType {
  confirmation,
  information,
  warning,
  error,
  input,
}

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;

  DialogButton({
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
  });
}

class DialogService {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required DialogType type,
    required String title,
    required String message,
    List<DialogButton>? buttons,
    TextEditingController? inputController,
    String? inputHint,
    String? inputLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: _buildDialogContent(
              context, type, message, inputController, inputHint, inputLabel),
          actions: buttons
                  ?.map((button) => _buildDialogButton(context, button))
                  .toList() ??
              [
                _buildDialogButton(
                    context,
                    DialogButton(
                        text: AppLocalizations.of(context)!.ok,
                        onPressed: () => Navigator.of(context).pop()))
              ],
        );
      },
    );
  }

  static Widget _buildDialogContent(
      BuildContext context,
      DialogType type,
      String message,
      TextEditingController? inputController,
      String? inputHint,
      String? inputLabel) {
    switch (type) {
      case DialogType.input:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: inputHint,
                labelText: inputLabel,
              ),
            ),
          ],
        );
      default:
        return Text(message);
    }
  }

  static Widget _buildDialogButton(BuildContext context, DialogButton button) {
    return button.isDestructive
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: button.onPressed,
            child: Text(
              button.text,
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          )
        : TextButton(
            onPressed: button.onPressed,
            child: Text(
              button.text,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          );
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) {
    return showCustomDialog<bool>(
      context: context,
      type: DialogType.confirmation,
      title: title,
      message: message,
      buttons: [
        DialogButton(
          text: cancelText ?? AppLocalizations.of(context)!.cancel,
          onPressed: () => context.pop(false),
        ),
        DialogButton(
          text: confirmText ?? AppLocalizations.of(context)!.confirm,
          onPressed: () => context.pop(true),
          isDestructive: true,
        ),
      ],
    );
  }
}
