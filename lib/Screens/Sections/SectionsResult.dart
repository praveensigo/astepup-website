import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../Widgets/Widgets.dart';

class SectionResult extends StatelessWidget {
  SectionResult({
    super.key,
    required this.sectionId,
  });

  final String courseId = getSavedObject(StorageKeys.courseId) ?? "";
  final lessonController = Get.find<LessonController>();
  final String moduleId = getSavedObject(StorageKeys.moduleId) ?? "";
  final String sectionId;
  final String stageId = getSavedObject(StorageKeys.stageId) ?? "";

  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;

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

  @override
  Widget build(BuildContext context) {
    String percentage =
        getValueOrNull(quizData['quiz_criteria'] ?? {}, 'percentage');
    int checkPercentage = convertStringToInteger(percentage);
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      initState: (_) {},
      didChangeDependencies: (state) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (getResultBool(
              userPercentage:
                  int.tryParse(state.controller?.quizPercetage ?? "0") ?? 0,
              checkPercentage: checkPercentage)) {
            state.controller?.courseRepository.updateUserSectionStatus(
                stageId: stageId.toString(),
                sectionId: sectionId.toString(),
                moduleId: moduleId.toString());
            await state.controller?.quizRepository.updateSectionQuizStatus(
                currentquizPercentage: state.controller!.quizPercetage,
                sectionid: sectionId,
                stageid: stageId,
                moduleid: moduleId,
                courseid: courseId);
            Get.find<SideMenuManager>().updateIsQuizComplete(
              int.parse(
                sectionId.toString(),
              ),
              MenuType.sectionQuiz,
            );
          }
        });
      },
      builder: (controller) {
        return LessonSectionLayout(
            body: SingleChildScrollView(
          child: Padding(
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
                                borderRadius: BorderRadius.circular(6))),
                        child: Text(
                          'FEEDBACK',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onPressed: () => feedbackDialog(context, sectionId),
                      ),
                    ),
                    Image.asset(AssetManager.result),
                    const SizedBox(height: 15),
                    Text(
                      controller.sectionName.isEmpty
                          ? getSavedObject(
                                  StorageKeys.quizData)['quiz_title'] ??
                              "Section title"
                          : controller.sectionName,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      controller.sectionDetail != null &&
                              controller
                                  .sectionDetail!.sectionDescription.isNotEmpty
                          ? controller.sectionDetail?.sectionDescription ??
                              "Section description"
                          : getSavedObject(StorageKeys.quizData)['quiz_decs'] ??
                              "Section description",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Total Score: ${controller.quizPercetage}%",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
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
                                minimumSize: Size(size.width / 5, 50)),
                            onPressed: () {
                              GoRouter.of(context)
                                  .go('/lesson/section/$sectionId');
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
                                  .go('/lesson/section-answer/$sectionId');
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
                                await nextButtonPress(
                                  controller,
                                  context,
                                );
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
                              )),
                        )
                      ],
                    )
                  ]))),
        ));
      },
    );
  }
}

void feedbackDialog(BuildContext context, String sectionId) {
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
                            FormData data = FormData.fromMap({
                              "feedback":
                                  controller.feedBackController.text.trim(),
                              "section_id": sectionId,
                            });
                            await controller.updateUserFeedback(
                                endPoint: ApiEndPoints.updateSectionFeedback,
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
