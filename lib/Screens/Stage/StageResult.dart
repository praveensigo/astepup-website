import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Tooltip.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';

import '../../Resource/AssetsManger.dart';
import '../../Resource/colors.dart';
import '../../Model/SidebarMenuItemModel.dart';
import '../Widgets/Widgets.dart';

class StageResult extends StatelessWidget {
  final String stageId;
  StageResult({super.key, required this.stageId});

  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;
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
            stageId: stageId,
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String percentage =
        getValueOrNull(quizData['quiz_criteria'] ?? {}, 'percentage');
    int checkPercentage = convertStringToInteger(percentage);
    return GetBuilder<QuizController>(
      init: QuizController(),
      didChangeDependencies: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          String courseId = getSavedObject(StorageKeys.courseId) ?? "";
          if (getResultBool(
              userPercentage: int.parse(state.controller!.quizPercetage),
              checkPercentage: checkPercentage)) {
            state.controller?.courseRepository.updateUserStageStatus(stageId);
            Get.find<SideMenuManager>().updateIsQuizComplete(
              int.parse(stageId),
              MenuType.stageQuiz,
            );
            state.controller?.quizRepository.updateStageQuizStatus(
                courseId: courseId,
                stageId: stageId,
                currentquizPercentage: state.controller!.quizPercetage);
          }
        });
      },
      builder: (controller) {
        return LessonSectionLayout(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(context).size.width < 950 ? 5 : 20,
                        horizontal:
                            MediaQuery.of(context).size.width < 950 ? 5 : 20,
                      ),
                    ),
                    onPressed: () => feedbackDialog(context),
                    child: Text(
                      'FEEDBACK',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Image.asset(
                  getResultBool(
                          userPercentage: int.parse(controller.quizPercetage),
                          checkPercentage: checkPercentage)
                      ? AssetManager.result
                      : AssetManager.resultFailed,
                  width: MediaQuery.of(context).size.width < 950 ? 130 : 180,
                ),
                const SizedBox(height: 15),
                Text(
                  "Stage Knowledge Appraisal Page",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.stagename.isEmpty
                      ? getSavedObject(StorageKeys.quizData)['quiz_title'] ??
                          "title"
                      : controller.stagename,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                Text(
                  "Total Score: ${controller.quizPercetage}%",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 15,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Result : ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: getResultText(
                                  userPercentage:
                                      int.parse(controller.quizPercetage),
                                  checkPercentage: checkPercentage),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: getResultColor(
                                          userPercentage: int.parse(
                                              controller.quizPercetage),
                                          checkPercentage: checkPercentage)))
                        ])),
                    CustomTooltip(
                      percentage: controller.quizPercetage,
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width / 5, 50)),
                        onPressed: () {
                          GoRouter.of(context).push('/lesson/stage/$stageId',
                              extra: {
                                'cid': getSavedObject(StorageKeys.courseId),
                                "selectedStageId": stageId
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width / 5, 50)),
                        onPressed: () {
                          GoRouter.of(context)
                              .push('/lesson/stage-answer-review/$stageId');
                        },
                        child: Text(
                          "REVIEW ANSWER",
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
                    PercentageWidgetBuilder(
                        userPercentage:
                            int.tryParse(controller.quizPercetage) ?? 0,
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
                            )))
                  ],
                )
              ],
            )),
          ),
        );
      },
    );
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
                                "stage_id": stageId,
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
}
