import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuid/uuid.dart';

import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Repository/CourseRepository.dart';

import '../Model/CourseDetails.dart';

enum LoadingStatus {
  courseLoading,
  stageLoding,
  complete,
  module,
  section,
  error
}

List<Map<String, dynamic>> courseProgressList = [
  {"title": "% Lessons completed", "icon": "Assets/Svg/lesson.svg"},
  {"title": "% Questions completed", "icon": "Assets/Svg/questions.svg"},
  {"title": "% Questions correct", "icon": "Assets/Svg/correct answer.svg"},
  {"title": " total spent", "icon": "Assets/Svg/hours.svg"}
];
List<Map<String, dynamic>> progressList = [
  {
    "title": "Lessons completed",
    "icon": "Assets/Svg/lesson.svg",
    'desc': "The percentage of lessons completed for the entire course."
  },
  {
    "title": "Questions completed",
    "icon": "Assets/Svg/questions.svg",
    'desc': "The percentage of questions completed for the entire course."
  },
  {
    "title": "Questions correct",
    "icon": "Assets/Svg/correct answer.svg",
    'desc':
        "Percentage of correct questions out of submitted questions for the entire course."
  },
  {
    "title": "Hour total spent",
    "icon": "Assets/Svg/hours.svg",
    'desc': "The total hours spent in this platform."
  }
];

class CourseDetailsController extends GetxController {
  AutoScrollController autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 20),
      axis: Axis.vertical);
  CourseDetails? courseDetails;
  String? courseId;
  LoadingStatus currentLoadingStatus = LoadingStatus.courseLoading;
  static Map<String, dynamic> offlineStorage = {};
  final courseRepository = CourseRepository();
  int? moduleid;
  ScrollController scrollController = ScrollController();
  int? sectionId;
  int? stageid;
  var uuid = const Uuid();

  @override
  void dispose() {
    autoScrollController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  animateScrollController(
      {int currentIndex = 0,
      double scrollOffset = 100,
      Duration duration = const Duration(milliseconds: 400),
      Curve curve = Curves.easeOutExpo}) {
    scrollController.animateTo(scrollOffset, duration: duration, curve: curve);
  }

  courseDetailsAPI(String courseId) async {
    try {
      courseDetails = await courseRepository.courseDetailsAPI(courseId,
          updateStorage: true);
      if (courseDetails != null) {
        currentLoadingStatus = LoadingStatus.stageLoding;
        update();
      } else {
        currentLoadingStatus = LoadingStatus.error;
        update();
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        print(e.toString());
        print(stackTrace.toString());
      }
      currentLoadingStatus = LoadingStatus.error;
      update();
    }
  }

  Future<StageDetail?> stageDetailsAPI(
    String stageId, {
    bool locked = false,
    required String cousreId,
  }) async {
    try {
      currentLoadingStatus = LoadingStatus.stageLoding;
      update();
      final stage = await courseRepository.stageDetailsAPI(stageId,
          cousreId: cousreId, updateStorage: true);
      if (stage != null) {
        currentLoadingStatus = LoadingStatus.module;
      }
      return stage;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          print('Error:${message}');
        } else {
          print('Error:${e.response?.data}');
        }
      } else {
        // showToast(e.toString());
        // throw Exception(e);
      }
    }
    return null;
  }

  Future<ModuleDetails?> moduleDetailsAPI(
    String moduleid, {
    required String stageId,
    required String cousreId,
  }) async {
    try {
      currentLoadingStatus = LoadingStatus.module;
      update();
      final module = await courseRepository.moduleDetailsAPI(moduleid,
          stageId: stageId, cousreId: cousreId, updateStorage: true);
      if (module != null) {
        currentLoadingStatus = LoadingStatus.section;
        update();
      }
      return module;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          print('Error:${message}');
        } else {
          print('Error:${e.response?.data}');
        }
      } else {
        print(e.toString());
      }
    }
    return null;
  }

  Future<SectionDetail?> sectionDetailsAPI(
    String sectionId, {
    required String stageId,
    required String moduleId,
  }) async {
    try {
      currentLoadingStatus = LoadingStatus.section;
      update();
      final sectionDetail = await courseRepository
          .sectionDetailsAPI(sectionId, moduleId, stageId, updateStorage: true);
      if (sectionDetail != null) {
        currentLoadingStatus = LoadingStatus.complete;
        update();
        return sectionDetail;
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
        update();
      } else {
        print(e.toString());
        throw Exception(e);
      }
    }
    return null;
  }
}
