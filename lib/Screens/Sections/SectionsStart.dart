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

class SectionStart extends StatefulWidget {
  final String sectionId;
  final String moduleId;
  final String stageId;

  const SectionStart({
    Key? key,
    required this.sectionId,
    required this.moduleId,
    required this.stageId,
  }) : super(key: key);

  @override
  State<SectionStart> createState() => _SectionStartState();
}

class _SectionStartState extends State<SectionStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<QuizController>(
          init: QuizController(),
          initState: (state) async {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              if (context.mounted) {
                Get.find<SideMenuManager>().retriveStageDetail(
                    getSavedObject(StorageKeys.stageDetails)
                            .containsKey("stages")
                        ? getSavedObject(StorageKeys.stageDetails)['stages']
                        : []);
                if (widget.stageId.isNotEmpty && widget.moduleId.isNotEmpty) {
                  savename(StorageKeys.stageId, widget.stageId);
                  savename(StorageKeys.moduleId, widget.moduleId);
                }
                String courseId = getSavedObject(StorageKeys.courseId) ?? "";
                String stageId = widget.stageId.isEmpty
                    ? getSavedObject(StorageKeys.stageId) ?? ""
                    : widget.stageId;
                String moduleId = widget.moduleId.isEmpty
                    ? getSavedObject(StorageKeys.moduleId) ?? ""
                    : widget.moduleId;
                await state.controller?.sectionDetailsAPI(widget.sectionId,
                    moduleid: moduleId, stageId: stageId, courseId: courseId);
              }
            });
          },
          builder: (controller) {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : LessonSectonBuilder(
                    imageUrl: AssetManager.documentInfo,
                    title: "Section Review Page",
                    subTitle:
                        controller.sectionDetail?.sectionName ?? "Section name",
                    descripton: controller.sectionDetail?.sectionDescription ??
                        "Section Description",
                    questionText:
                        "${controller.sectionDetail?.questionCount ?? 0} Questions",
                    buttonText: "START",
                    onPressed: () {
                      GoRouter.of(context)
                          .push('/lesson/section-review/${widget.sectionId}');
                    },
                    questionCount: controller.sectionDetail == null
                        ? "0"
                        : controller.sectionDetail!.questionCount.toString(),
                  );
          }),
    );
  }
}
