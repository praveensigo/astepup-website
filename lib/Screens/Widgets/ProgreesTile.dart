import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:astepup_website/Resource/colors.dart';

class ProgressTile extends StatelessWidget {
  final String title;
  final String icon;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final bool isTextOnly;
  final TextStyle? titleStyle;
  final MainAxisAlignment mainAxisAlignment;
  const ProgressTile({
    super.key,
    required this.title,
    required this.icon,
    this.decoration,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.isTextOnly = false,
    this.titleStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return isTextOnly
        ? Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
          )
        : Container(
            width: width,
            constraints: const BoxConstraints(minWidth: 245),
            height: height ?? 50,
            margin: margin ?? const EdgeInsets.symmetric(horizontal: 7.5),
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: decoration ??
                BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.circular(10)),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 25,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle ??
                          Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                ]),
          );
  }
}
