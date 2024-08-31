import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Model/QuestionSummaryModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/ReviewAnswerWidget.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';

import '../Widgets/PercentageWidget.dart';

class StageAnswerReview extends StatefulWidget {
  final String stageId;
  const StageAnswerReview({super.key, required this.stageId});

  @override
  State<StageAnswerReview> createState() => _StageAnswerReviewState();
}

class _StageAnswerReviewState extends State<StageAnswerReview> {
  Future<void> nextButtonPress(
      QuizController controller, BuildContext context) async {
    try {
      String courseId = getSavedObject(StorageKeys.courseId) ?? "0";
      Map<String, dynamic> data =
          getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
      final finalMastryQuizCount = data['final_mastery']['question_count'] ?? 0;
      final finalMastryQuizComplete =
          data['final_mastery']['is_quiz_complete'] ?? false;
      final stageList = data['stages'] as List<dynamic>;

      for (int stageIndex = 0; stageIndex < stageList.length; stageIndex++) {
        var stageStatus = await Quizhelper.getStageStatus(
            controller: controller,
            context: context,
            stageList: stageList,
            stageId: widget.stageId,
            courseId: courseId,
            stageIndex: stageIndex);
        if (stageStatus == null) {
          return;
        }
      }
      if (finalMastryQuizCount > 0 && !finalMastryQuizComplete) {
        if (context.mounted) {
          var selectedKey = data['final_mastery']['key'] ?? "";
          GoRouter.of(context).go(
              '/lesson/mastery/${getSavedObject(StorageKeys.courseId)}',
              extra: {'selectedKey': selectedKey});
        }
        return;
      } else {
        controller.courseRepository.updateUserCourseStatus(courseId);
        var details = getSavedObject(StorageKeys.stageDetails);
        savename(StorageKeys.courseId, courseId);
        savename("courseName", details['course_name']);
        if (context.mounted) {
          if (data['final_mastery']['evaluation_status'] == '2') {
            GoRouter.of(context).go('/certificate');
          } else {
            GoRouter.of(context).go('/evaluation-survey');
          }
        }
        return;
      }
    } catch (e, stackTrace) {
      debugPrint('error in stage ${e.toString()}');
      debugPrint('error in stackTrace ${stackTrace.toString()}');
    }
  }

  void feedbackDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          var controller = Get.find<LessonController>();
          return Center(
              child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(minWidth: 360),
              width: size.width * .45,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Text(
                      "Feedback",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: controller.feedBackController,
                      maxLines: 5,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your feedback";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Feedback here',
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (controller.formKey.currentState!.validate()) {
                              FormData data = FormData.fromMap({
                                "feedback":
                                    controller.feedBackController.text.trim(),
                                "stage_id": widget.stageId,
                              });
                              await controller.updateUserFeedback(
                                  endPoint: ApiEndPoints.updateStagefeedback,
                                  data: data);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            "Send",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }

  @override
  void initState() {
    var controller = Get.find<QuizController>();
    if (controller.questionlist.isEmpty) {
      getSavedObject(StorageKeys.quizList)['quiz']
          .map((e) => controller.questionlist.add(Question.fromJson(e)))
          .toList();
      setState(() {});
    }
    super.initState();
  }

  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;
  @override
  Widget build(BuildContext context) {
    String percentage =
        getValueOrNull(quizData['quiz_criteria'] ?? {}, 'percentage');
    int checkPercentage = convertStringToInteger(percentage);
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      initState: (_) {},
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
          child: ReviewAnswerWidget(
            currentQuiz: CurrentQuiz.stage,
            retakeWidget: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width / 5, 50)),
                onPressed: () {
                  GoRouter.of(context).push('/lesson/stage/${widget.stageId}',
                      extra: {
                        'cid': getSavedObject(StorageKeys.courseId),
                        "selectedStageId": widget.stageId
                      });
                },
                child: Text(
                  "RETAKE",
                  style: size.width < 550
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold)
                      : Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                )),
            nextWidget: PercentageWidgetBuilder(
                userPercentage: int.tryParse(controller.quizPercetage) ?? 0,
                checkPercentage: checkPercentage,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width / 5, 50)),
                    onPressed: () async {
                      await nextButtonPress(controller, context);
                    },
                    child: Text(
                      "NEXT",
                      style: size.width < 550
                          ? Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)
                          : Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                    ))),
            title: 'Stage Knowledge Appraisal Page',
            totalPercentage: controller.quizPercetage,
            answersList: List.generate(
                controller.questionlist.length,
                (index) => QuestionSummary(
                    questionId:
                        controller.questionlist[index].questionId.toString(),
                    question: controller.questionlist[index].question,
                    answers:
                        controller.questionlist[index].selectedChoice?.choice ??
                            "",
                    isCorrect: (controller
                                .questionlist[index].selectedChoice?.choice ??
                            "") ==
                        controller.questionlist[index].answer,
                    currentAnswer: controller.questionlist[index].answer)),
            feedbackWidget: () {
              feedbackDialog(context);
            },
          ),
        );
      },
    );
  }
}
