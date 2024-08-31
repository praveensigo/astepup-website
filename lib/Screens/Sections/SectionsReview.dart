import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Awidget/reviewbuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';

class SectionReview extends StatefulWidget {
  final String sectionid;
  const SectionReview({
    super.key,
    required this.sectionid,
  });

  @override
  State<SectionReview> createState() => _SectionReviewState();
}

String sectionroute = '';

class _SectionReviewState extends State<SectionReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var courseId = getSavedObject(StorageKeys.courseId);
          if (context.mounted) {
            state.controller!.sectionQuizDetail(widget.sectionid, courseId);
          }
        });
      }, builder: (controller) {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: colorPrimary,
                ),
              )
            : QuizReviewBuilderWidget(
                nextRoute: '/lesson/section-result/${widget.sectionid}',
                pageTitle: controller.sectionName,
                questionCount: controller.questionlist.length,
                questionList: controller.questionlist,
                quizId: widget.sectionid,
                route: 'section',
              );
      }),
    );
  }
}
