import 'package:flutter/material.dart';
import 'package:mymy_m1/services/dialogs/dialog_service.dart';

class LoginScreenTips extends StatelessWidget {
  const LoginScreenTips({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => DialogService.showCustomDialog(
              context,
              title: "Tips",
              type: DialogType.information,
              message: 'Tips details',
            ),
        icon: const Icon(Icons.info_outline_rounded));
  }
}
