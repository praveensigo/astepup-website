import 'package:flutter/material.dart';

import '../../Resource/colors.dart';

class ColoredContainer extends StatelessWidget {
  final Widget? child;
  final BoxConstraints? constraints;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  const ColoredContainer({
    super.key,
    this.child,
    this.constraints,
    this.border,
    this.borderRadius,
    this.color,
    this.padding,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: alignment,
      constraints: constraints ??
          const BoxConstraints(minWidth: 200, maxWidth: 850, maxHeight: 600),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          border: border ?? Border.all(color: borderColor, width: 1.4)),
      child: child,
    ));
  }
}
