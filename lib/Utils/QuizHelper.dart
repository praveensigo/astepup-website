import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../Resource/Strings.dart';

class Quizhelper {
  static final sideMenuManager = Get.find<SideMenuManager>();
  static Future<String?> getStageStatus(
      {required QuizController controller,
      required BuildContext context,
      required List<dynamic> stageList,
      required String stageId,
      required String courseId,
      required int stageIndex}) async {
    final previousStage = stageIndex > 0
        ? stageList.elementAtOrNull(stageIndex - 1) as Map<String, dynamic>?
        : null;
    final nextStage = stageIndex < stageList.length - 1
        ? stageList.elementAtOrNull(stageIndex + 1) as Map<String, dynamic>?
        : null;
    final previousStageQuizComplete =
        (previousStage?['stage_quiz_completed_status'] ?? 0) == 1;
    if (previousStage != null && !previousStageQuizComplete) {
      showToast(Strings.stageQuizError);
      return null;
    }
    if (nextStage != null) {
      await controller.nextStageApi(stageId, courseId, context);
      return null;
    }
    return 'done';
  }

  static Future<String?> getModuleStatus(
      {required QuizController controller,
      required BuildContext context,
      required List<dynamic> moduleList,
      required String stageId,
      required String courseId,
      required String moduleId,
      required int moduleIndex}) async {
    final previousModule = moduleIndex > 0
        ? moduleList.elementAtOrNull(moduleIndex - 1) as Map<String, dynamic>?
        : null;
    // final currentModule =
    //     moduleList.elementAtOrNull(moduleIndex) as Map<String, dynamic>?;
    final nextModule = moduleIndex < moduleList.length - 1
        ? moduleList.elementAtOrNull(moduleIndex + 1) as Map<String, dynamic>?
        : null;
    final previousModuleQuizComplete =
        (previousModule?['module_quiz_completed_status'] ?? 0) == 1;
    // final isModuleQuizComplete =
    //     (currentModule?['module_quiz_completed_status'] ?? 0) == 1;
    if (previousModule != null && !previousModuleQuizComplete) {
      showToast(Strings.moduleQuizError);
      return null;
    } else if (nextModule != null) {
      await controller.nextModuleApi(moduleId, stageId, courseId, context);
      return null;
    } else {
      QuizInfo stageQuizInfo =
          getQuizCountAndStatus(int.parse(stageId), MenuType.stageQuiz);
      if (stageQuizInfo.questionCount > 0 && stageQuizInfo.quizStatus != 1) {
        sideMenuManager.sideBarController.selectItem(stageQuizInfo.key);
        var selectedKey = stageQuizInfo.key;
        GoRouter.of(rootNavigatorKey.currentContext!).go(
            '/lesson/stage/$stageId',
            extra: {'cid': courseId, 'selectedKey': selectedKey});
        return null;
      } else {
        await controller.courseRepository.updateUserStageStatus(stageId);
      }
      return 'done';
    }
  }

  static Future<String?> getSectionStatus(
      {required QuizController controller,
      required BuildContext context,
      required List<dynamic> sectionList,
      required String stageId,
      required String courseId,
      required String moduleId,
      required String sectionId,
      required int sectionIndex}) async {
    final previousSection = sectionIndex > 0
        ? sectionList.elementAtOrNull(sectionIndex - 1) as Map<String, dynamic>?
        : null;
    final nextSection = sectionIndex < sectionList.length - 1
        ? sectionList.elementAtOrNull(sectionIndex + 1) as Map<String, dynamic>?
        : null;
    final previousSectionQuizComplete =
        (previousSection?['section_quiz_completed_status'] ?? 0) == 1;
    if (previousSection != null && !previousSectionQuizComplete) {
      showToast(Strings.sectionQuizError);
      return null;
    }
    if (nextSection != null) {
      await controller.nextSectionApi(
          sectionId, stageId, courseId, moduleId, context);
      return null;
    } else {
      QuizInfo moduleQuizInfo =
          getQuizCountAndStatus(int.parse(moduleId), MenuType.moduleQuiz);
      if (moduleQuizInfo.questionCount > 0 && moduleQuizInfo.quizStatus != 1) {
        sideMenuManager.sideBarController.selectItem(moduleQuizInfo.key);
        var selectedKey = moduleQuizInfo.key;
        GoRouter.of(rootNavigatorKey.currentContext!)
            .go('/lesson/module/$moduleId', extra: {
          'cid': courseId,
          'sid': stageId,
          'selectedKey': selectedKey
        });
        return null;
      } else {
        await controller.courseRepository
            .updateUserModuleStatus(stageId, moduleId);
        QuizInfo stageQuizInfo =
            getQuizCountAndStatus(int.parse(stageId), MenuType.stageQuiz);
        if (stageQuizInfo.questionCount > 0 && stageQuizInfo.quizStatus != 1) {
          sideMenuManager.sideBarController.selectItem(stageQuizInfo.key);
          var selectedKey = stageQuizInfo.key;
          GoRouter.of(rootNavigatorKey.currentContext!).go(
              '/lesson/stage/$stageId',
              extra: {'cid': courseId, 'selectedKey': selectedKey});
          return null;
        } else {
          await controller.courseRepository.updateUserStageStatus(stageId);
          return 'data';
        }
      }
    }
  }

  static bool quizLockStatus(MenuType type, Map<String, dynamic> data) {
    //completed_status api status
    //1-pending, 2-ongoing, 3-completed
    switch (type) {
      case MenuType.sectionQuiz:
        return false;
      case MenuType.moduleQuiz:
        final sections = (data['module_section_status'] ?? []) as List<dynamic>;
        final sectionCompleteStatus = sections.firstWhereOrNull(
          (section) =>
              section['completed_status'] == 1 ||
              section['completed_status'] == 2,
        );
        return data['dependent'] == 1 && sectionCompleteStatus != null;
      case MenuType.stageQuiz:
        final modules = (data['stage_module_status'] ?? []) as List<dynamic>;
        final moduleCompleteStatus = modules.firstWhereOrNull(
          (module) =>
              module['completed_status'] == 1 ||
              module['completed_status'] == 2,
        );
        return data['dependent'] == 1 && moduleCompleteStatus != null;
      case MenuType.finalMasteryQuiz:
        final stages = (data['course_stage_status'] ?? []) as List<dynamic>;
        final stageCompleteStatus = stages.firstWhereOrNull(
          (stage) =>
              stage['completed_status'] == 1 || stage['completed_status'] == 2,
        );
        return stageCompleteStatus != null;
      default:
        return false;
    }
  }

  static bool quizCompleteStatus(MenuType type, Map<String, dynamic> data) {
    //quiz_result
    //0-pending, 1-completed
    switch (type) {
      case MenuType.sectionQuiz:
        return data['section_quiz_completed_status'] == 1;
      case MenuType.moduleQuiz:
        return data['module_quiz_completed_status'] == 1;
      case MenuType.stageQuiz:
        return data['stage_quiz_completed_status'] == 1;
      case MenuType.finalMasteryQuiz:
        return data['is_quiz_complete'] ?? false;
      default:
        return false;
    }
  }

  static Map<String, dynamic>? findItemByKey(
      Map<String, dynamic> jsonData, String searchKey) {
    if (jsonData.containsKey('key') && jsonData['key'] == searchKey) {
      return jsonData;
    }
    for (var key in jsonData.keys) {
      var value = jsonData[key];
      if (value is Map<String, dynamic>) {
        var result = findItemByKey(value, searchKey);
        if (result != null) return result;
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            var result = findItemByKey(item, searchKey);
            if (result != null) return result;
          }
        }
      }
    }
    return null;
  }

  static QuizInfo getQuizCountAndStatus(int targetId, MenuType menuType) {
    Map<String, dynamic> stageDetails =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;

    QuizInfo findQuizInfo(
        Map<String, dynamic> item, int targetId, MenuType menuType) {
      if (menuType == MenuType.sectionQuiz) {
        if (item.containsKey('section_id') && item['section_id'] == targetId) {
          int questionCount = item['question_count'] ?? 0;
          int quizStatus = item['section_quiz_completed_status'] ?? 0;
          return QuizInfo(
            questionCount: questionCount,
            quizStatus: quizStatus,
            key: item['quiz_key'],
          );
        }
      } else if (menuType == MenuType.moduleQuiz) {
        if (item.containsKey('module_id') && item['module_id'] == targetId) {
          int questionCount = item['question_count'] ?? 0;
          int quizStatus = item['module_quiz_completed_status'] ?? 0;
          return QuizInfo(
            questionCount: questionCount,
            quizStatus: quizStatus,
            key: item['quiz_key'],
          );
        }
      } else if (menuType == MenuType.stageQuiz) {
        if (item.containsKey('id') && item['id'] == targetId) {
          int questionCount = item['question_count'] ?? 0;
          int quizStatus = item['stage_quiz_completed_status'] ?? 0;
          return QuizInfo(
            questionCount: questionCount,
            quizStatus: quizStatus,
            key: item['quiz_key'],
          );
        }
      }
      return QuizInfo(questionCount: 0, quizStatus: 0, key: '');
    }

    QuizInfo recursiveFindQuizInfo(
        Map<String, dynamic> item, int targetId, MenuType menuType) {
      // Check if the item matches the target type and id and return quiz info
      QuizInfo quizInfo = findQuizInfo(item, targetId, menuType);
      if (quizInfo.questionCount != 0 || quizInfo.quizStatus != 0) {
        return quizInfo;
      }

      // Traverse through modules if present
      if (item.containsKey('modules')) {
        for (var module in item['modules']) {
          quizInfo = findQuizInfo(module, targetId, menuType);
          if (quizInfo.questionCount != 0 || quizInfo.quizStatus != 0) {
            return quizInfo;
          }
          quizInfo = recursiveFindQuizInfo(module, targetId, menuType);
          if (quizInfo.questionCount != 0 || quizInfo.quizStatus != 0) {
            return quizInfo;
          }
        }
      }

      // Traverse through sections if present
      if (item.containsKey('sections')) {
        for (var section in item['sections']) {
          quizInfo = findQuizInfo(section, targetId, menuType);
          if (quizInfo.questionCount != 0 || quizInfo.quizStatus != 0) {
            return quizInfo;
          }
        }
      }

      return QuizInfo(questionCount: 0, quizStatus: 0, key: '');
    }

    if (menuType == MenuType.finalMasteryQuiz) {
      if (stageDetails.containsKey('final_mastery')) {
        var finalMastery = stageDetails['final_mastery'];
        if (finalMastery['id'] == targetId) {
          int questionCount = finalMastery['question_count'] ?? 0;
          int quizStatus =
              finalMastery['final_mastery_quiz_completed_status'] ?? 0;
          return QuizInfo(
              questionCount: questionCount,
              quizStatus: quizStatus,
              key: finalMastery['quiz_key']);
        }
      }
    }

    for (var stage in stageDetails['stages']) {
      QuizInfo quizInfo = recursiveFindQuizInfo(stage, targetId, menuType);
      if (quizInfo.questionCount != 0 || quizInfo.quizStatus != 0) {
        return quizInfo;
      }
    }

    return QuizInfo(questionCount: 0, quizStatus: 0, key: '');
  }
}

class QuizInfo {
  final int questionCount;
  final int quizStatus;
  final String key;

  QuizInfo({
    required this.questionCount,
    required this.quizStatus,
    required this.key,
  });
}
