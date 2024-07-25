import 'package:flutter/material.dart';

class BottomSheetService {
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.2,
    double maxChildSize = 0.75,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: builder,
      ),
    );
  }
}
