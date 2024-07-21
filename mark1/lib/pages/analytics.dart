import 'package:flutter/material.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return mainView(context, body: const CustomText(text: "Analytics"));
  }
}
