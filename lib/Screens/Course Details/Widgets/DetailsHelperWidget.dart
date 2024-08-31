import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:astepup_website/Screens/Widgets/ProgreesTile.dart';
import 'package:astepup_website/Utils/Utils.dart';

class TitleBuilder extends StatelessWidget {
  const TitleBuilder({
    super.key,
    required this.isMobile,
    required this.title,
  });

  final bool isMobile;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 6)
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: AutoSizeText(
        title,
        maxLines: 2,
        maxFontSize: 24,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

List<Map<String, dynamic>> datalist = [
  {"title": "% Lessons completed", "icon": "Assets/Svg/lesson.svg"},
  {"title": "% Questions completed", "icon": "Assets/Svg/questions.svg"},
  {"title": "% Questions correct", "icon": "Assets/Svg/correct answer.svg"},
  {"title": " total spent", "icon": "Assets/Svg/hours.svg"}
];

class CourseStatusWidgetMobile extends StatelessWidget {
  final String lessonComplete;
  final String quizComplete;
  final String quizCorrectAnswer;
  final String totalHour;
  const CourseStatusWidgetMobile({
    super.key,
    required this.lessonComplete,
    required this.quizComplete,
    required this.quizCorrectAnswer,
    required this.totalHour,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        ProgressTile(
          width: double.infinity,
          title: "$lessonComplete${datalist[0]['title']}",
          icon: datalist[0]['icon'],
        ),
        ProgressTile(
          width: double.infinity,
          title: "${limitPercentageValue(quizComplete)}${datalist[1]['title']}",
          icon: datalist[1]['icon'],
        ),
        ProgressTile(
          width: double.infinity,
          title:
              "${limitPercentageValue(quizCorrectAnswer)}${datalist[2]['title']}",
          icon: datalist[2]['icon'],
        ),
        ProgressTile(
          width: double.infinity,
          title: "$totalHour${datalist[3]['title']}",
          icon: datalist[3]['icon'],
        )
        // AutoSizeText("$lessonComplete % lessons completed",
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(fontWeight: FontWeight.bold)),
        // AutoSizeText("$quizComplete % Question completed",
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(fontWeight: FontWeight.bold)),
        // AutoSizeText("$quizCorrectAnswer % Question correct",
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(fontWeight: FontWeight.bold)),
        // AutoSizeText("$totalHour total spent",
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(fontWeight: FontWeight.bold))
      ],
    );
  }
}
