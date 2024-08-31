import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuid/uuid.dart';

import 'package:astepup_website/Repository/CourseRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/Sidebar/flutter_sidebar.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/titleBuilder.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../Model/SidebarMenuItemModel.dart';

class SideMenuManager extends GetxController {
  SideMenuManager({this.selectedStageId, this.selectedItemKeyUrl});

  int autoScrollIndex = 0;
  final controller = AutoScrollController(
      viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 10),
      axis: Axis.vertical,
      suggestedRowHeight: 200);

  String courseId = getSavedObject(StorageKeys.courseId) ?? "";

  SideMenuItem? selectedItem;
  String? selectedItemKeyUrl;
  final String? selectedStageId;
  final StreamController<List<SideMenuItem>> _sideBarStreamController =
      StreamController<List<SideMenuItem>>.broadcast();
  Stream<List<SideMenuItem>> get sideBarStream =>
      _sideBarStreamController.stream;

  List<SideMenuItem> sideBarList = [];
  String stageDetailsStoreKey = StorageKeys.stageDetails;
  var uuid = const Uuid();
  final courseRepository = CourseRepository();
  final sideBarController = SidebarController();

  @override
  void onInit() async {
    retriveStageDetail(getSavedObject(stageDetailsStoreKey)['stages'] ?? []);
    if (selectedItemKeyUrl != null && selectedItemKeyUrl!.isNotEmpty) {
      savename(StorageKeys.selectedKey, selectedItemKeyUrl);
      sideBarController.selectItem(selectedItemKeyUrl ?? "");
    }
    super.onInit();
  }

  @override
  void dispose() {
    _sideBarStreamController.close();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    listenKey(
        key: StorageKeys.stageDetails,
        callback: (value) async {
          if (value != null) {
            Map<String, dynamic> data = json.decode(value);
            retriveStageDetail(data['stages'] ?? []);
            update();
          }
        });
  }

  void retriveStageDetail(List<dynamic> stages) {
    sideBarList.clear();
    final finalMastery = getSavedObject(stageDetailsStoreKey)['final_mastery'];
    try {
      stages.asMap().forEach((index, stage) {
        final stageName = stage['name']?.toString() ?? '';
        final stageId = stage['id']?.toString() ?? '';
        if (stageName.isEmpty || stageId.isEmpty) return;
        final modules = stage['modules'] as List<dynamic>? ?? [];
        final stageKey = stage['key'] ?? uuid.v4();
        final isLastStage = index == stages.length - 1;
        sideBarList.add(
          createSideMenuItem(
            key: stageKey,
            currentData: stage,
            isLocked: stage['is_locked'] ?? true,
            currentIndex: index,
            isExpanded: stage['is_expanded'] ?? false,
            route: "Stage ${index + 1}: $stageName",
            id: stageId,
            type: MenuType.stage,
            isLastStage: isLastStage,
            title: "Stage ${index + 1}: $stageName",
            idMapper: IdMap(stageId: stageId, courseId: courseId),
            children: [
              ...modules.asMap().map((moduleIndex, module) {
                return MapEntry(
                    moduleIndex,
                    createModuleItem(module, stage, moduleIndex, stageKey,
                        stageId, isLastStage));
              }).values,
              if (stage['question_count'] != null)
                createQuizItem(
                    item: stage,
                    parentKey: stageKey,
                    index: index,
                    isLastStage: isLastStage,
                    quizId: stageId.toString(),
                    idMap: IdMap(
                      stageId: stageId.toString(),
                      courseId: courseId,
                    ),
                    quizTitle: "Stage ${index + 1} Knowledge Appraisal",
                    itemType: MenuType.stageQuiz),
              if (isLastStage && finalMastery['question_count'] != null)
                createFinalMasteryItem(
                    finalMastery: finalMastery,
                    stageKey: stageKey,
                    stageId: stageId,
                    index: index),
            ],
          ),
        );
      });
      updateSideBarList(sideBarList);
      sideBarController.tabs = sideBarList;
    } catch (e, stackTrace) {
      debugPrint("Error:$e");
      debugPrint("stackTrace:$stackTrace");
    }
    update();
  }

  SideMenuItem createSideMenuItem({
    required String key,
    required dynamic currentData,
    required bool isLocked,
    required int currentIndex,
    required bool isExpanded,
    required String route,
    required String id,
    required MenuType type,
    required bool isLastStage,
    required String title,
    required IdMap idMapper,
    required List<SideMenuItem?> children,
    String duration = '',
  }) {
    return SideMenuItem(
      key: key,
      currentData: currentData,
      currentIndex: currentIndex,
      isExpanded: isExpanded,
      titleString: route,
      id: id,
      type: type,
      isLastStage: isLastStage,
      title: type == MenuType.section
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SideBarTitleBuilder(
                    title: title,
                    sectionTitle: true,
                    color: const Color(0xff333333).withOpacity(.9),
                  ),
                ),
                MediaQuery.of(rootNavigatorKey.currentContext!).size.width < 590
                    ? const SizedBox()
                    : Row(
                        children: [
                          const SizedBox(width: 5),
                          SectionTimeBuilder(
                            duration: duration,
                          )
                        ],
                      )
              ],
            )
          : SideBarTitleBuilder(title: title),
      idMapper: idMapper,
      children: children.whereType<SideMenuItem>().toList(),
    );
  }

  SideMenuItem? createModuleItem(dynamic module, dynamic stage, int moduleIndex,
      String stageKey, String stageId, bool isLastStage) {
    final moduleName = module['module_name'];
    final moduleId = module['module_id'];
    if (moduleName == null || moduleId == null) return null;
    final sections = module['sections'] as List<dynamic>? ?? [];
    final moduleKey = module['key'] ?? uuid.v4();
    final isLastModule = moduleIndex == sections.length - 1;
    return createSideMenuItem(
      key: moduleKey,
      currentData: module,
      isLocked: module['is_locked'] ?? true,
      currentIndex: moduleIndex,
      isExpanded: module['is_expanded'] ?? false,
      route: "Module ${moduleIndex + 1}: $moduleName",
      id: moduleId.toString(),
      type: MenuType.module,
      isLastStage: isLastStage,
      title: "Module ${moduleIndex + 1}: $moduleName",
      idMapper: IdMap(
          moduleId: moduleId.toString(), stageId: stageId, courseId: courseId),
      children: [
        ...sections.asMap().map((sectionIndex, section) {
          return MapEntry(
              sectionIndex,
              createSectionItem(
                  section: section,
                  module: module,
                  stage: stage,
                  sectionIndex: sectionIndex,
                  moduleKey: moduleKey,
                  moduleId: moduleId.toString(),
                  stageId: stageId,
                  isLastStage: isLastStage,
                  isLastModule: isLastModule,
                  isLastSection: sectionIndex == sections.length - 1));
        }).values,
        if (module['question_count'] != null)
          createQuizItem(
            item: module,
            parentKey: moduleKey,
            index: moduleIndex,
            isLastStage: isLastStage,
            isLastModule: isLastModule,
            quizId: moduleId.toString(),
            idMap: IdMap(
              moduleId: moduleId.toString(),
              stageId: stageId.toString(),
              courseId: courseId,
            ),
            quizTitle: "Module ${moduleIndex + 1} Concept Check",
            itemType: MenuType.moduleQuiz,
          ),
      ],
    );
  }

  SideMenuItem? createSectionItem({
    required dynamic section,
    required dynamic module,
    required dynamic stage,
    required int sectionIndex,
    required String moduleKey,
    required String moduleId,
    required String stageId,
    required bool isLastStage,
    required bool isLastModule,
    required bool isLastSection,
  }) {
    final sectionName = section['section_name'];
    final sectionId = section['section_id'];
    if (sectionName == null || sectionId == null) return null;
    final videos = section['videos'] as List<dynamic>? ?? [];
    final sectionKey = section['key'] ?? uuid.v4();
    return createSideMenuItem(
      key: sectionKey,
      currentData: section,
      isLocked: section['is_locked'] ?? true,
      currentIndex: sectionIndex,
      isExpanded: section['is_expanded'] ?? false,
      route: "Section ${sectionIndex + 1}: $sectionName",
      id: sectionId.toString(),
      type: MenuType.section,
      isLastStage: isLastStage,
      title: "Section ${sectionIndex + 1}: $sectionName",
      duration: section['total_time'],
      idMapper: IdMap(
          sectionId: sectionId.toString(),
          moduleId: moduleId,
          stageId: stageId,
          courseId: courseId),
      children: [
        ...videos.asMap().map((videoIndex, video) {
          return MapEntry(
              videoIndex,
              createVideoItem(
                  video: video,
                  videoIndex: videoIndex,
                  sectionKey: sectionKey,
                  stage: stage,
                  module: stage,
                  section: section,
                  moduleId: moduleId,
                  stageId: stageId,
                  courseId: courseId,
                  isLastStage: isLastStage,
                  isLastModule: isLastModule));
        }).values,
        if (section['question_count'] != null)
          createQuizItem(
            item: section,
            parentKey: sectionKey,
            index: sectionIndex,
            isLastStage: isLastStage,
            isLastModule: isLastModule,
            isLastSection: isLastSection,
            quizId: sectionId.toString(),
            idMap: IdMap(
              sectionId: sectionId.toString(),
              moduleId: moduleId.toString(),
              stageId: stageId.toString(),
              courseId: courseId,
            ),
            quizTitle: "Section ${sectionIndex + 1} Review",
            itemType: MenuType.sectionQuiz,
          ),
        createNextButton(
            section: section,
            module: module,
            stage: stage,
            isLastStage: isLastStage)
      ],
    );
  }

  SideMenuItem? createVideoItem(
      {required dynamic video,
      required int videoIndex,
      required String sectionKey,
      required dynamic module,
      required dynamic stage,
      required dynamic section,
      required String moduleId,
      required String stageId,
      required String courseId,
      required bool isLastStage,
      required bool isLastModule}) {
    final videoStatus =
        (section['video_status'] as List?)?.elementAtOrNull(videoIndex);
    if (video == null || videoStatus == null) return null;
    final videoKey = video['key'];
    return SideMenuItem(
      key: videoKey,
      currentData: {
        'videoData': video,
        'videoStauts': videoStatus,
        'section': section,
        'module': module,
        'stage': stage,
      },
      parentKey: sectionKey,
      titleString: video['video_name'] ?? '',
      currentIndex: videoIndex,
      id: video['video_id'].toString(),
      type: MenuType.video,
      isLastVideo: videoIndex == (section['videos'] as List).length - 1,
      idMapper: IdMap(
          sectionId: section['section_id'].toString(),
          moduleId: moduleId,
          stageId: stageId,
          courseId: courseId),
      title: LessonTile(
        isLessonPage: true,
        isCompleted: videoStatus['watch_status'] == 1,
        title: video['video_name'] ?? '',
        presenter: video['presenter'],
        duration: video['video_duration'],
        verticalAlign: true,
      ),
    );
  }

  SideMenuItem? createQuizItem(
      {required dynamic item,
      required String parentKey,
      required int index,
      bool isLastStage = false,
      bool isLastModule = false,
      bool isLastSection = false,
      required MenuType itemType,
      required String quizTitle,
      required String quizId,
      required IdMap idMap}) {
    final quizKey = item['quiz_key'] ?? uuid.v4();
    if ((item['question_count'] ?? 0) == 0) return null;
    return SideMenuItem(
        key: quizKey,
        currentData: item,
        parentKey: parentKey,
        titleString: quizTitle,
        id: quizId,
        currentIndex: index,
        type: itemType,
        idMapper: idMap,
        isLastStage: isLastStage,
        isLastModule: isLastModule,
        isLastSection: isLastSection);
  }

  SideMenuItem? createFinalMasteryItem(
      {required dynamic finalMastery,
      required String stageKey,
      required int index,
      required String stageId}) {
    if ((finalMastery['question_count'] ?? 0) == 0) return null;
    return SideMenuItem(
      key: finalMastery['quiz_key'] ?? uuid.v4(),
      currentData: finalMastery,
      parentKey: stageKey,
      titleString: "Final Mastery Assessment",
      id: courseId,
      currentIndex: index,
      idMapper: IdMap(
        stageId: stageId.toString(),
        courseId: courseId,
      ),
      type: MenuType.finalMasteryQuiz,
      isLastStage: true,
      title: SectionTile(
        iconSize: 17,
        isCompleted: Quizhelper.quizCompleteStatus(
            MenuType.finalMasteryQuiz, finalMastery),
        isLessonLocked:
            Quizhelper.quizLockStatus(MenuType.finalMasteryQuiz, finalMastery),
        title: "Final Mastery Assessment",
        subtitle: "${finalMastery['question_count'] ?? 0} Qs",
        isLessonPage: true,
      ),
    );
  }

  SideMenuItem? createNextButton(
      {required dynamic section,
      required dynamic module,
      required dynamic stage,
      bool isLastStage = false}) {
    final finalMastery = getSavedObject(stageDetailsStoreKey)['final_mastery'];
    if ((section['question_count'] ?? 0) == 0 &&
        (module['question_count'] ?? 0) == 0 &&
        (stage['question_count'] ?? 0) == 0 &&
        (finalMastery['question_count'] ?? 0) == 0 &&
        isLastStage) {
      return SideMenuItem(
          key: uuid.v4(),
          type: MenuType.unvaild,
          id: "",
          title: ElevatedButton(
              onPressed: () {
                courseRepository.updateUserCourseStatus(courseId);
                var details = getSavedObject(StorageKeys.stageDetails);
                savename(StorageKeys.courseId, courseId);
                savename("courseName", details['course_name']);
                if (finalMastery['evaluation_status'] == '2') {
                  GoRouter.of(rootNavigatorKey.currentContext!)
                      .go('/certificate');
                } else {
                  GoRouter.of(rootNavigatorKey.currentContext!)
                      .go('/evaluation-survey');
                }
              },
              child: Text(
                "Next",
                style: Theme.of(rootNavigatorKey.currentContext!)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              )));
    }
    return null;
  }

  void updateSideBarList(List<SideMenuItem> newSideBarList) {
    _sideBarStreamController.sink.add(sideBarList);
    _sideBarStreamController.done;
  }

  SideMenuItem? findItemByKey(List<SideMenuItem?> data, String key) {
    try {
      if (data.isNotEmpty) {
        for (var item in data) {
          if (item?.key == key) {
            return item;
          }
          if (item != null && item.children.isNotEmpty) {
            var result = findItemByKey(item.children, key);
            if (result != null) {
              return result;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error in findItemByKey:${e.toString()}");
    }
    return null;
  }

  void updateIsQuizComplete(int targetId, MenuType menuType) {
    Map<String, dynamic> stageDetails =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;

    // Function to update the 'is_quiz_complete' field
    bool updateKey(Map<String, dynamic> item, int targetId, MenuType menuType) {
      if (menuType == MenuType.sectionQuiz) {
        if (item.containsKey('section_id') && item['section_id'] == targetId) {
          item['section_completed_status'] = 1;
          item['section_quiz_completed_status'] = 1;
          item['is_quiz_complete'] = true;
          return true;
        }
      } else if (menuType == MenuType.moduleQuiz) {
        if (item.containsKey('module_id') && item['module_id'] == targetId) {
          item['module_completed_status'] = 1;
          item['module_quiz_completed_status'] = 1;
          item['is_quiz_complete'] = true;
          return true;
        }
      } else {
        if (item.containsKey('id') && item['id'] == targetId) {
          final finalyMastery =
              getSavedObject(StorageKeys.stageDetails)['final_mastery'];
          finalyMastery['course_stage_status'].forEach((e) {
            if (e['stage_id'] == item['id']) {
              e['completed_status'] == 3;
            }
          });
          getSavedObject(StorageKeys.stageDetails)['course_stage_status']
              .forEach((e) {
            if (e['stage_id'] == item['id']) {
              e['completed_status'] == 3;
            }
          });
          item['stage_completed_status'] = 1;
          item['stage_quiz_completed_status'] = 1;
          item['is_quiz_complete'] = true;
          return true;
        }
      }
      return false;
    }

    // Recursive function to traverse and update
    bool recursiveUpdate(
        Map<String, dynamic> item, int targetId, MenuType menuType) {
      // Update if the item matches the target type and id
      if (menuType == MenuType.stageQuiz &&
          updateKey(item, targetId, menuType)) {
        return true;
      }

      // Traverse through modules if present
      if (item.containsKey('modules')) {
        for (var module in item['modules']) {
          if (menuType == MenuType.moduleQuiz &&
              updateKey(module, targetId, menuType)) {
            return true;
          }
          if (recursiveUpdate(module, targetId, menuType)) {
            return true;
          }
        }
      }

      // Traverse through sections if present
      if (item.containsKey('sections')) {
        for (var section in item['sections']) {
          if (menuType == MenuType.sectionQuiz &&
              updateKey(section, targetId, menuType)) {
            return true;
          }
        }
      }

      return false;
    }

    if (menuType == MenuType.finalMasteryQuiz) {
      if (stageDetails.containsKey('final_mastery')) {
        var finalMastery = stageDetails['final_mastery'];
        if (finalMastery['id'] == targetId) {
          finalMastery['is_quiz_complete'] = true;
          savename(StorageKeys.stageDetails, stageDetails);
          retriveStageDetail(stageDetails['stages']);
          return;
        }
      }
    }

    for (var stage in stageDetails['stages']) {
      if (recursiveUpdate(stage, targetId, menuType)) {
        break;
      }
    }

    savename(StorageKeys.stageDetails, stageDetails);
    retriveStageDetail(stageDetails['stages']);
  }

  Map<String, dynamic>? getSectionById(String sectionId) {
    for (var stage in getSavedObject(stageDetailsStoreKey).containsKey("stages")
        ? getSavedObject(stageDetailsStoreKey)['stages']
        : []) {
      for (var module in stage['modules']) {
        for (var section in module['sections']) {
          if (section['section_id'].toString() == sectionId) {
            return section;
          }
        }
      }
    }
    return null;
  }

  Map<String, dynamic>? getStageById(String stageId) {
    for (var stage in getSavedObject(stageDetailsStoreKey).containsKey("stages")
        ? getSavedObject(stageDetailsStoreKey)['stages']
        : []) {
      if (stage['id'].toString() == stageId) {
        return stage;
      }
    }
    return null;
  }

  Map<String, dynamic>? getModuleById(String moduleId) {
    for (var stage in getSavedObject(stageDetailsStoreKey).containsKey("stages")
        ? getSavedObject(stageDetailsStoreKey)['stages']
        : []) {
      for (var module in stage['modules']) {
        if (module['module_id'].toString() == moduleId) {
          return module;
        }
      }
    }
    return null;
  }
}
