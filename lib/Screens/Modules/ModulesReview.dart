import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Awidget/reviewbuilder.dart';

import '../../Resource/Strings.dart';
import '../../Utils/Utils.dart';

class ModuleReview extends StatefulWidget {
  final String moduleId;
  const ModuleReview({super.key, required this.moduleId});

  @override
  State<ModuleReview> createState() => _ModuleReviewState();
}

String moduleroute = '';

class _ModuleReviewState extends State<ModuleReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var courseId = getSavedObject(StorageKeys.courseId);
          if (context.mounted) {
            state.controller!.moduleQuizDetail(widget.moduleId, courseId);
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
                nextRoute: '/lesson/module-result/${widget.moduleId}',
                pageTitle: controller.moduleName,
                questionCount: controller.questionlist.length,
                questionList: controller.questionlist,
                quizId: widget.moduleId,
                route: 'module',
              );
      }),
    );
  }
}
