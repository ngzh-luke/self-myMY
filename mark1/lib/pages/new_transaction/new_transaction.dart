import 'package:flutter/material.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  @override
  Widget build(BuildContext context) {
    return mainView(context, body: const CustomText(text: "New Transaction"));
  }
}
