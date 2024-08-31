import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/ReviewAnswerWidget.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';

import '../../Controller/QuizController.dart';
import '../../Model/QuestionSummaryModel.dart';

class MasteryAssesmentSummery extends StatefulWidget {
  const MasteryAssesmentSummery({super.key});

  @override
  State<MasteryAssesmentSummery> createState() =>
      _MasteryAssesmentSummeryState();
}

class _MasteryAssesmentSummeryState extends State<MasteryAssesmentSummery> {
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
                      maxLines: 5,
                      controller: controller.feedBackController,
                      decoration: InputDecoration(
                          hintText: 'Feedback here',
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your feedback";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (controller.formKey.currentState!.validate()) {
                              String courseId =
                                  getSavedObject(StorageKeys.courseId) ?? "";
                              FormData data = FormData.fromMap({
                                "feedback":
                                    controller.feedBackController.text.trim(),
                                "course_id": courseId,
                              });
                              await controller.updateUserFeedback(
                                  endPoint: ApiEndPoints.updateCourseFeedback,
                                  data: data);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text("Send")),
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }

  final String moduleId = getSavedObject(StorageKeys.moduleId) ?? "";
  final String stageId = getSavedObject(StorageKeys.stageId) ?? "";
  final String sectionId = getSavedObject(StorageKeys.sectionId) ?? "";

  Future<void> nextButtonPress(
      BuildContext context, QuizController controller) async {
    try {
      final String courseId = getSavedObject(StorageKeys.courseId) ?? "";
      Map<String, dynamic> data =
          getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
      List<dynamic> stageList = data['stages'];
      for (int stageIndex = 0; stageIndex < stageList.length; stageIndex++) {
        final currentStage = stageList[stageIndex] as Map<String, dynamic>;
        final currentStageId = currentStage['id'].toString();
        if (currentStageId == stageId) {
          final modulesList = currentStage['modules'] as List<dynamic>;
          for (int moduleIndex = 0;
              moduleIndex < modulesList.length;
              moduleIndex++) {
            final currentModule =
                modulesList[moduleIndex] as Map<String, dynamic>;
            final currentModuleId = currentModule["module_id"].toString();
            if (currentModuleId == moduleId) {
              final sectionList = currentModule['sections'] as List<dynamic>;
              for (int sectionIndex = 0;
                  sectionIndex < sectionList.length;
                  sectionIndex++) {
                final currentSection =
                    sectionList[sectionIndex] as Map<String, dynamic>;
                final currentSectionId =
                    currentSection["section_id"].toString();
                if (currentSectionId == sectionId) {
                  var sectionStatus = await Quizhelper.getSectionStatus(
                      controller: controller,
                      context: context,
                      sectionList: sectionList,
                      stageId: stageId,
                      courseId: courseId,
                      moduleId: moduleId,
                      sectionId: sectionId,
                      sectionIndex: sectionIndex);
                  if (sectionStatus == null) {
                    return;
                  }
                }
              }
              var mouduleStatus = await Quizhelper.getModuleStatus(
                  controller: controller,
                  context: context,
                  moduleList: modulesList,
                  stageId: stageId,
                  courseId: courseId,
                  moduleId: moduleId,
                  moduleIndex: moduleIndex);
              if (mouduleStatus == null) {
                return;
              }
            }
          }
          var stageStatus = await Quizhelper.getStageStatus(
              controller: controller,
              context: context,
              stageList: stageList,
              stageId: stageId,
              courseId: courseId,
              stageIndex: stageIndex);
          if (stageStatus == null) {
            return;
          }
        }
      }
      clearBackNavigationStack(
          currentPath: "/", context: context, nextPath: "/");
      var finalmastery =
          getSavedObject(StorageKeys.stageDetails)['final_mastery'];
      if (finalmastery['evaluation_status'] == '2') {
        GoRouter.of(context).go('/certificate');
        return;
      } else {
        GoRouter.of(context).go('/evaluation-survey');
        return;
      }
    } catch (e, stackTrace) {
      debugPrint('error in final ${e.toString()}');
      debugPrint('error in stackTrace ${stackTrace.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      initState: (state) {},
      builder: (controller) {
        return ReviewAnswerWidget(
          title: 'Final Mastery Assessment Page',
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
                  isCorrect:
                      (controller.questionlist[index].selectedChoice?.choice ??
                              "") ==
                          controller.questionlist[index].answer,
                  currentAnswer: controller.questionlist[index].answer)),
          currentQuiz: CurrentQuiz.mastery,
          nextWidget: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width / 5, 50),
            ),
            onPressed: () {
              nextButtonPress(context, controller);
            },
            child: Text(
              "VIEW CERTIFICATE",
              style: size.width < 550
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          retake: "/lesson/mastery-review/${getSavedObject("courseId")}",
          feedbackWidget: () {
            feedbackDialog(context);
          },
        );
      },
    );
  }
}
