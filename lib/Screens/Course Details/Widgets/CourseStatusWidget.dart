import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CourseStatusWidget extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String icon;
  final bool isMobile;
  const CourseStatusWidget({
    super.key,
    required this.title,
    this.titleStyle,
    required this.icon,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: isMobile ? 5 : 10),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isMobile
              ? Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w900,
                  )
              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
        )
      ],
    );
  }
}
