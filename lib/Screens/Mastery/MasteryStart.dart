import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Screens/Widgets/LessonSectionBuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../../Controller/SidebarManager.dart';
import '../../Resource/Strings.dart';

class MasteryStart extends StatelessWidget {
  final String courseId;
  MasteryStart({super.key, required this.courseId});
  String courseroute = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<QuizController>(
            init: QuizController(),
            initState: (state) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                state.controller?.courseDetailsApi(courseId);
                Get.find<SideMenuManager>().retriveStageDetail(
                    getSavedObject(StorageKeys.stageDetails)
                            .containsKey("stages")
                        ? getSavedObject(StorageKeys.stageDetails)['stages']
                        : []);
              });
            },
            builder: (controller) {
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : LessonSectonBuilder(
                      imageUrl: AssetManager.documentInfo,
                      title: "Final Mastery Assessment Page",
                      subTitle:
                          controller.courseDetails?.courseName ?? "Course one",
                      descripton: controller.courseDetails?.courseDescription ??
                          "Course one description",
                      questionText:
                          "${controller.courseDetails?.questionCount ?? 0} Questions",
                      onPressed: () {
                        if (context.mounted) {
                          context.push('/lesson/mastery-review/$courseId');
                        }
                      },
                      buttonText: "START",
                      questionCount:
                          (controller.courseDetails?.questionCount ?? 0)
                              .toString());
            }));
  }
}
