import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Awidget/reviewbuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../../Resource/Strings.dart';

class StageReview extends StatelessWidget {
  final String stageId;
  StageReview({super.key, required this.stageId});
  String stageroute = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(
          init: QuizController(),
          initState: (state) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              var courseId = getSavedObject(StorageKeys.courseId);

              if (context.mounted) {
                await state.controller?.stageQuizDetail(stageId, courseId);
              }
            });
          },
          builder: (controller) {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: colorPrimary,
                    ),
                  )
                : QuizReviewBuilderWidget(
                    nextRoute: '/lesson/stage-result/$stageId',
                    pageTitle: controller.stagename,
                    questionCount: controller.questionlist.length,
                    questionList: controller.questionlist,
                    route: 'stage',
                    quizId: stageId,
                  );
          }),
    );
  }
}
