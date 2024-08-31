import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';

import '../Widgets/Widgets.dart';

class ModulesResult extends StatelessWidget {
  ModulesResult({super.key, required this.moduleId});

  String courseId = getSavedObject(StorageKeys.courseId) ?? "0";
  final String moduleId;
  String stageId = getSavedObject(StorageKeys.stageId) ?? "0";
  String sectionId = getSavedObject(StorageKeys.sectionId) ?? "0";

  Future<void> nextButtonPress(
      QuizController controller, BuildContext context) async {
    try {
      final data =
          getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
      final finalMastryQuizCount = data['final_mastery']['question_count'] ?? 0;
      final finalMastryQuizComplete =
          data['final_mastery']['is_quiz_complete'] ?? false;
      final stageList = data['stages'] as List<dynamic>;

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
              var moduleStatus = await Quizhelper.getModuleStatus(
                  controller: controller,
                  context: context,
                  moduleList: modulesList,
                  stageId: stageId,
                  courseId: courseId,
                  moduleId: currentModuleId,
                  moduleIndex: moduleIndex);
              if (moduleStatus == null) {
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
      if (finalMastryQuizCount > 0 && !finalMastryQuizComplete) {
        var selectedKey = data['final_mastery']['key'] ?? "";
        GoRouter.of(context).go(
            '/lesson/mastery/${getSavedObject(StorageKeys.courseId)}',
            extra: {'selectedKey': selectedKey});
        return;
      } else {
        controller.courseRepository.updateUserCourseStatus(courseId);
        var details = getSavedObject(StorageKeys.stageDetails);
        savename(StorageKeys.courseId, courseId);
        savename("courseName", details['course_name']);
        if (data['final_mastery']['evaluation_status'] == '2') {
          if (context.mounted) {
            GoRouter.of(context).go('/certificate');
          }
        } else {
          if (context.mounted) {
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

  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;
  @override
  Widget build(BuildContext context) {
    String percentage =
        getValueOrNull(quizData['quiz_criteria'] ?? {}, 'percentage');
    int checkPercentage = convertStringToInteger(percentage);
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          courseId = getSavedObject(StorageKeys.courseId) ?? "";
          if (context.mounted) {
            if (getResultBool(
                userPercentage:
                    int.tryParse(state.controller?.quizPercetage ?? "0") ?? 0,
                checkPercentage: checkPercentage)) {
              state.controller?.courseRepository
                  .updateUserModuleStatus(stageId, moduleId);
              state.controller?.quizRepository.updateModuleQuizStatus(
                  courseId: courseId,
                  stageId: stageId,
                  moduleId: moduleId,
                  currentquizPercentage:
                      state.controller?.quizPercetage ?? "0");
              Get.find<SideMenuManager>().updateIsQuizComplete(
                int.parse(moduleId),
                MenuType.moduleQuiz,
              );
            }
          }
        });
      },
      builder: (controller) {
        return LessonSectionLayout(
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                                  borderRadius: BorderRadius.circular(6))),
                          child: Text(
                            'FEEDBACK',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onPressed: () =>
                              moduelFeedbackDialog(context, moduleId),
                        ),
                      ),
                      Image.asset(AssetManager.result),
                      const SizedBox(height: 15),
                      Text(
                        "Module Concept Check Page",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        controller.moduleName.isEmpty
                            ? getSavedObject(
                                    StorageKeys.quizData)['quiz_title'] ??
                                "title"
                            : controller.moduleName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Total Score: ${controller.quizPercetage}%",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 35),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 15,
                        runSpacing: 15,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // maximumSize: Size(400, 50),
                                  minimumSize: Size(size.width / 5, 50)),
                              onPressed: () {
                                GoRouter.of(context)
                                    .push('/lesson/module/$moduleId', extra: {
                                  'cid': courseId,
                                  'sid': stageId,
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
                                    .push('/lesson/module-answer/$moduleId');
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
                                            .copyWith(
                                                fontWeight: FontWeight.bold)
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                  )))
                        ],
                      )
                    ]))));
      },
    );
  }
}

void moduelFeedbackDialog(BuildContext context, String moduleId) {
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
                              "module_id": moduleId,
                            });
                            await controller.updateUserFeedback(
                                endPoint: ApiEndPoints.updateModuleFeedback,
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
