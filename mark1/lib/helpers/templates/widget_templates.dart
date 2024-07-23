import 'package:flutter/material.dart';

abstract class AbCustomText extends StatelessWidget {
  final String text;
  final TextStyle? customStyle;

  const AbCustomText({
    required this.text,
    this.customStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: (customStyle ?? const TextStyle()).copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        )
        // backgroundColor: Theme.of(context).colorScheme.secondary),
        );
  }
}

class CustomText extends AbCustomText {
  const CustomText({
    required super.text,
    TextStyle? style,
    super.key,
  }) : super(customStyle: style);
}
