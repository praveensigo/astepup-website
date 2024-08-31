import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Widgets/LessonSectionBuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';

class StageStart extends StatelessWidget {
  final String stageId;
  StageStart({super.key, required this.stageId});
  String stageroute = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(
          initState: (state) {
            stageroute = getroute(context);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Get.find<SideMenuManager>().retriveStageDetail(
                  getSavedObject(StorageKeys.stageDetails).containsKey("stages")
                      ? getSavedObject(StorageKeys.stageDetails)['stages']
                      : []);
              String courseId = getSavedObject(StorageKeys.courseId) ?? "";
              state.controller?.stageDetailsAPI(stageId, courseId);
            });
          },
          init: QuizController(),
          builder: (controller) {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : LessonSectonBuilder(
                    imageUrl: AssetManager.documentInfo,
                    title: "Stage Knowledge Appraisal Page",
                    subTitle: controller.stagedetail?.stageName ?? 'Stage name',
                    descripton: controller.stagedetail?.stageDescription ??
                        "Stage description",
                    questionText:
                        "${controller.stagedetail?.questionCount ?? 0} Questions",
                    onPressed: () {
                      if (context.mounted) {
                        context.push('/lesson/stage-review/$stageId');
                      }
                    },
                    buttonText: "START",
                    questionCount: controller.stagedetail == null
                        ? "0"
                        : controller.stagedetail!.questionCount.toString(),
                  );
          }),
    );
  }
}
