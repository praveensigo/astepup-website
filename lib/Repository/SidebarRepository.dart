import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/titleBuilder.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../Controller/LessonController.dart';
import '../Controller/SidebarManager.dart';
import '../Model/SidebarMenuItemModel.dart';
import '../Screens/Screens.dart';

class SidebarRepository {
  var lessonController = Get.find<LessonController>();
  var sideMenuController = Get.find<SideMenuManager>();
  var uuid = const Uuid();
  Future<bool> getStageItems(SideMenuItem item) async {
    var finalMastery = getSavedObject('stageDetails')['final_mastery'];
    StageDetail? stages = await lessonController.stageDetailsAPI(item.id,
        cousreId: item.idMapper?.courseId.toString() ?? "");
    if (stages != null) {
      item.children.clear();
      for (int i = 0; i < stages.modules.length; i++) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            parentKey: item.key,
            currentIndex: i,
            idMapper: IdMap(
                stageId: stages.stageId.toString(),
                courseId: item.idMapper?.courseId.toString()),
            title: SideBarTitleBuilder(
              title: "Modules ${i + 1}: ${stages.modules[i].moduleName}",
              color: const Color(0xff333333).withOpacity(.9),
            ),
            type: MenuType.module,
            children: [],
            id: stages.modules[i].moduleId.toString()));
      }
      if (stages.questionCount > 0) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            parentKey: item.key,
            idMapper: IdMap(
                stageId: stages.stageId.toString(),
                courseId: item.idMapper?.courseId.toString()),
            titleString: "Stage ${item.currentIndex + 1} Knowledge Appraisal",
            type: MenuType.stageQuiz,
            id: stages.stageId.toString()));
      }
      if (item.isLastStage && (finalMastery['question_count'] ?? 0) > 0) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            parentKey: item.key,
            idMapper: IdMap(
                stageId: stages.stageId.toString(),
                courseId: item.idMapper?.courseId.toString()),
            titleString: "Final Mastery Assessment",
            type: MenuType.finalMasteryQuiz,
            id: stages.stageId.toString()));
      }
      return true;
    } else {
      item.children.clear();
      showSnackBar(
          msg: Strings.depenedCommonError,
          context: rootNavigatorKey.currentContext!);
      return false;
    }
  }

  Future<bool> getModuleItems(SideMenuItem item) async {
    ModuleDetails? moudule = await lessonController.moduleDetailsAPI(item.id,
        stageId: item.idMapper?.stageId == null
            ? ''
            : item.idMapper!.stageId.toString(),
        courseId: item.idMapper?.courseId == null
            ? ''
            : item.idMapper!.courseId.toString());
    if (moudule != null) {
      item.children.clear();
      for (int i = 0; i < moudule.sections.length; i++) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            currentIndex: i,
            parentKey: item.key,
            idMapper: IdMap(
                moduleId: moudule.moduleId.toString(),
                stageId: item.idMapper?.stageId.toString(),
                courseId: item.idMapper?.courseId.toString()),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SideBarTitleBuilder(
                    title:
                        "Section ${i + 1}: ${moudule.sections[i].sectionName}",
                    sectionTitle: true,
                    color: const Color(0xff333333).withOpacity(.9),
                  ),
                ),
                const SizedBox(width: 5),
                SectionTimeBuilder(
                  duration: moudule.sections[i].totalTime,
                )
              ],
            ),
            type: MenuType.section,
            children: [],
            id: moudule.sections[i].sectionId.toString()));
      }
      if (moudule.questionCount > 0) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            parentKey: item.key,
            titleString: "Module ${item.currentIndex + 1} Concept Check",
            idMapper: IdMap(
                moduleId: moudule.moduleId.toString(),
                stageId: item.idMapper?.stageId.toString(),
                courseId: item.idMapper?.courseId.toString()),
            type: MenuType.moduleQuiz,
            id: moudule.moduleId.toString()));
      }
      return true;
    } else {
      item.children.clear();

      showSnackBar(
          msg: Strings.depenedCommonError,
          context: rootNavigatorKey.currentContext!);

      return false;
    }
  }

  Future<bool> getSectionItems(SideMenuItem item,
      {bool isLastModule = false, bool isLastStage = false}) async {
    SectionDetail? section;
    section = await lessonController.sectionDetailsAPI(
      item.id,
      stageId: item.idMapper?.stageId ?? "",
      moduleId: item.idMapper!.moduleId,
      courseId: item.idMapper!.courseId,
    );

    if (section != null) {
      item.children.clear();
      for (int i = 0; i < section.videos.length; i++) {
        item.children.add(SideMenuItem(
            key: uuid.v4(),
            parentKey: item.key,
            titleString: "Video ${i + 1} ${section.videos[i].videoName}",
            id: section.videos[i].videoId.toString(),
            type: MenuType.video,
            idMapper: IdMap(
              sectionId: section.sectionId.toString(),
              moduleId: item.idMapper?.moduleId.toString(),
              stageId: item.idMapper?.stageId.toString(),
              courseId: item.idMapper?.courseId.toString(),
            ),
            title: LessonTile(
              isCompleted:
                  section.videoStatus.elementAtOrNull(i)?.watchStatus == 1,
              title: section.videos[i].videoName,
              presenter: section.videos[i].presenter,
              duration: section.videos[i].videoDuration,
              verticalAlign: true,
              isLessonPage: true,
            )));
      }
      if (section.questionCount > 0) {
        item.children.add(SideMenuItem(
          key: uuid.v4(),
          parentKey: item.key,
          titleString: "Section ${item.currentIndex + 1} Review",
          id: section.sectionId.toString(),
          idMapper: IdMap(
            sectionId: section.sectionId.toString(),
            moduleId: item.idMapper?.moduleId.toString(),
            stageId: item.idMapper?.stageId.toString(),
            courseId: item.idMapper?.courseId.toString(),
          ),
          type: MenuType.sectionQuiz,
        ));
      }
      return true;
    } else {
      item.children.clear();
      showSnackBar(
          msg: Strings.depenedCommonError,
          context: rootNavigatorKey.currentContext!);
      return false;
    }
  }
}
