import 'package:flutter/material.dart';

class TextTitleBuilder extends StatelessWidget {
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final String title;
  final String subtitle;
  const TextTitleBuilder({
    super.key,
    this.titleStyle,
    this.subtitleStyle,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: subtitleStyle,
        ),
      ],
    );
  }
}
