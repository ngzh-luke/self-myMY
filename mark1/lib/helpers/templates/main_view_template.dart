import 'package:flutter/material.dart';

Scaffold mainView(BuildContext context,
    {String? appBarTitle = 'changeMe',
    required Widget body,
    List<Widget>? appbarActions = const [],
    Color? appBarBackgroundColor}) {
  return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: appBarBackgroundColor ??
            Theme.of(context).colorScheme.onPrimaryFixed,
        title: Text(
          appBarTitle!,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: appbarActions,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: body);
}
