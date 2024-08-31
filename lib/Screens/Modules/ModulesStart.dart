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

class ModuleStart extends StatefulWidget {
  final String moduleId;
  final String stageId;

  const ModuleStart({
    Key? key,
    required this.moduleId,
    required this.stageId,
  }) : super(key: key);

  @override
  State<ModuleStart> createState() => _ModulesStartState();
}

String moduleroute = '';

class _ModulesStartState extends State<ModuleStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(
          initState: (state) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              Get.find<SideMenuManager>().retriveStageDetail(
                  getSavedObject(StorageKeys.stageDetails).containsKey("stages")
                      ? getSavedObject(StorageKeys.stageDetails)['stages']
                      : []);

              if (widget.stageId.isNotEmpty) {
                savename(StorageKeys.stageId, widget.stageId);
              }
              String courseId = getSavedObject(StorageKeys.courseId) ?? "";
              String stageid = widget.stageId.isEmpty
                  ? getSavedObject(StorageKeys.stageId) ?? ""
                  : widget.stageId;

              if (context.mounted) {
                await state.controller!
                    .moduleDetailsAPI(widget.moduleId, stageid, courseId);
              }
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
                    title: "Module Concept Check Page",
                    subTitle:
                        controller.moduleDetails?.moduleName ?? "Module Name",
                    descripton: controller.moduleDetails?.moduleDescription ??
                        "Module Description",
                    questionText:
                        "${controller.moduleDetails?.questionCount ?? 0} Questions",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/lesson/module-review/${widget.moduleId}');
                    },
                    buttonText: "START",
                    questionCount: controller.moduleDetails == null
                        ? "0"
                        : controller.moduleDetails!.questionCount.toString(),
                  );
          }),
    );
  }
}
