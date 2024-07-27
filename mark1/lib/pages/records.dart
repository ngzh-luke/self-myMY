import 'package:flutter/material.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return mainView(context,
        appBarTitle: AppLocalizations.of(context)!.heading_records,
        body: const CustomText(text: "Transaction Records"));
  }
}
