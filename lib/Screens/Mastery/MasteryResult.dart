import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Tooltip.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../../Controller/LessonController.dart';
import '../Widgets/Widgets.dart';

class MasteryResult extends StatelessWidget {
  final String courseId;
  MasteryResult({super.key, required this.courseId});
  final formKey = GlobalKey<FormState>();
  final TextEditingController feedbackController = TextEditingController();
  final Map<String, dynamic> quizData =
      getSavedObject(StorageKeys.quizData) as Map<String, dynamic>;
  final String moduleId = getSavedObject(StorageKeys.moduleId) ?? "";
  final String stageId = getSavedObject(StorageKeys.stageId) ?? "";
  final String sectionId = getSavedObject(StorageKeys.sectionId) ?? "";

  Future<void> nextButtonPress(
      BuildContext context, QuizController controller) async {
    try {
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
    int checkPercentage =
        convertStringToInteger(quizData['quiz_criteria']["percentage"]);
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      initState: (_) {},
      didChangeDependencies: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context.mounted) {
            if (getResultBool(
                userPercentage: int.parse(state.controller!.quizPercetage),
                checkPercentage: checkPercentage)) {
              state.controller?.courseRepository
                  .updateUserCourseStatus(courseId);
              Get.find<SideMenuManager>().updateIsQuizComplete(
                int.parse(courseId),
                MenuType.finalMasteryQuiz,
              );
            }
            state.controller?.quizRepository.updateCourseQuizStatus(
                courseId: courseId,
                currentquizPercentage: state.controller?.quizPercetage ?? "0");
          }
        });
      },
      builder: (controller) {
        return LessonSectionLayout(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        getResultBool(
                                userPercentage:
                                    int.parse(controller.quizPercetage),
                                checkPercentage: checkPercentage)
                            ? AssetManager.result
                            : AssetManager.resultFailed,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Final Mastery Assessment Page",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width < 950
                                  ? 15
                                  : 25,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        controller.courseName.isEmpty
                            ? getSavedObject(
                                    StorageKeys.quizData)['quiz_title'] ??
                                "title"
                            : controller.courseName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Total Score: ${controller.quizPercetage}%",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width < 950
                                  ? 15
                                  : 20,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 5,
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
                                                checkPercentage:
                                                    checkPercentage)))
                              ])),
                          CustomTooltip(
                            percentage: controller.quizPercetage,
                          )
                        ],
                      ),
                      const SizedBox(height: 35),
                      Wrap(
                        spacing: 15.0,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width / 5, 50),
                            ),
                            onPressed: () {
                              GoRouter.of(context)
                                  .go('/lesson/mastery/$courseId');
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
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width / 5, 50),
                            ),
                            onPressed: () {
                              GoRouter.of(context)
                                  .go('/lesson/mastery-assesment_summery');
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
                            ),
                          ),
                          PercentageWidgetBuilder(
                            userPercentage: int.parse(controller.quizPercetage),
                            checkPercentage: checkPercentage,
                            child: ElevatedButton(
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
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.10),
                        child: TextFormField(
                          maxLines: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your feedback";
                            }
                            return null;
                          },
                          controller: feedbackController,
                          decoration: InputDecoration(
                            hintText: 'Feedback here',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: borderColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: 200, maxWidth: 400),
                        child: ElevatedButton(
                          onPressed: () async {
                            var controller = Get.find<LessonController>();
                            if (formKey.currentState!.validate()) {
                              FormData data = FormData.fromMap({
                                "feedback": feedbackController.text.trim(),
                                "course_id": courseId,
                              });
                              await controller.updateUserFeedback(
                                  endPoint: ApiEndPoints.updateCourseFeedback,
                                  data: data);
                              feedbackController.clear();
                            }
                          },
                          child: Text(
                            "SEND",
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
