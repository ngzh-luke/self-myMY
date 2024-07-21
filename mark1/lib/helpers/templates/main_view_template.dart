import 'package:flutter/material.dart';

Scaffold mainView(BuildContext context,
    {String? appBarTitle = 'changeMe', required Widget body}) {
  return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appBarTitle!),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: body);
}
