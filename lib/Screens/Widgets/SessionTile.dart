import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isLessonLocked;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final bool isMobile;
  final bool isLessonPage;
  const SectionTile({
    super.key,
    this.isLessonLocked = false,
    this.isCompleted = false,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.iconSize,
    this.isMobile = false,
    this.isLessonPage = false,
    this.padding = EdgeInsets.zero,
  }) : assert(iconSize != null, "enter a icon size");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isCompleted
              ? Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: green, shape: BoxShape.circle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    )
                  ],
                )
              : SvgPicture.asset(
                  isLessonLocked ? CustomIcons.lock : CustomIcons.questions,
                  width: iconSize! + 10,
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle ??
                        (isMobile
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: isLessonPage
                                    ? FontWeight.normal
                                    : FontWeight.w700)
                            : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: isLessonPage
                                    ? FontWeight.normal
                                    : FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    AutoSizeText(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle ??
                          (isMobile
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: isLessonPage
                                          ? FontWeight.normal
                                          : FontWeight.w700)
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: isLessonPage
                                      ? FontWeight.normal
                                      : FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
