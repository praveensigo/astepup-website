import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';

class LessonTile extends StatefulWidget {
  final String duration;
  final String presenter;
  final String title;
  final bool isCompleted;
  final bool isLessonLocked;
  final TextStyle? titleStyle;
  final double? iconSize;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final bool verticalAlign;
  final bool isLessonPage;
  final bool isSelected;
  final Future<bool?> Function()? onTapCallback;
  const LessonTile({
    super.key,
    required this.title,
    this.isLessonPage = false,
    this.isLessonLocked = false,
    this.isCompleted = false,
    this.verticalAlign = false,
    this.isSelected = false,
    this.titleStyle,
    this.subtitleStyle,
    this.iconSize = 20,
    this.padding = EdgeInsets.zero,
    this.duration = "10 min",
    this.onTapCallback,
    this.presenter = "presenter",
  });

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  bool? watchStatusUpdate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          watchStatusUpdate ?? widget.isCompleted
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
                        size: widget.iconSize,
                      ),
                    )
                  ],
                )
              : SvgPicture.asset(
                  widget.isLessonLocked
                      ? CustomIcons.lock
                      : CustomIcons.videoPlay,
                  width: widget.iconSize! + 10,
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
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: widget.titleStyle ??
                        Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: widget.isLessonPage
                                ? widget.isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal
                                : FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 15),
                widget.verticalAlign
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(CustomIcons.playtime),
                                const SizedBox(width: 10),
                                AutoSizeText(
                                  widget.duration,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: widget.subtitleStyle ??
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ]),
                          const SizedBox(height: 10),
                          AutoSizeText(
                            "Presenter : ${widget.presenter}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: widget.subtitleStyle ??
                                Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          SvgPicture.asset(CustomIcons.playtime),
                          const SizedBox(width: 10),
                          AutoSizeText(
                            widget.duration,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.subtitleStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 2,
                            height: 30,
                            color: textColor,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: AutoSizeText(
                              "Presenter : ${widget.presenter}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: widget.subtitleStyle ??
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 10),
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
