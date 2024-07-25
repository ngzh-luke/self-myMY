import 'package:flutter/material.dart';

class BottomSheetNotifier extends InheritedWidget {
  final Function(bool) setBottomSheetState;

  const BottomSheetNotifier({
    super.key,
    required this.setBottomSheetState,
    required super.child,
  });

  static BottomSheetNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomSheetNotifier>();
  }

  @override
  bool updateShouldNotify(BottomSheetNotifier oldWidget) {
    return setBottomSheetState != oldWidget.setBottomSheetState;
  }
}
