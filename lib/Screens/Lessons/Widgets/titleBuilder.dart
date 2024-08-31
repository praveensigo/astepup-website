import 'package:flutter/material.dart';

class SideBarTitleBuilder extends StatelessWidget {
  final String title;
  final Color? color;
  final bool? sectionTitle;
  const SideBarTitleBuilder({
    super.key,
    required this.title,
    this.color,
    this.sectionTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: sectionTitle!
          ? Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: color ?? Colors.black, fontWeight: FontWeight.w600)
          : Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: color ?? Colors.black, fontWeight: FontWeight.w900),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
