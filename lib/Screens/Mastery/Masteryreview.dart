import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Awidget/reviewbuilder.dart';

class MasteryReview extends StatelessWidget {
  final String courseId;
  MasteryReview({super.key, required this.courseId});
  String courseroute = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(initState: (state) async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (context.mounted) {
            await state.controller?.courseQuizDetail(courseId);
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
                nextRoute: '/lesson/mastery-Result/$courseId',
                pageTitle: controller.courseName,
                questionCount: controller.questionlist.length,
                questionList: controller.questionlist,
                quizId: courseId,
                route: 'course',
              );
      }),
    );
  }
}
