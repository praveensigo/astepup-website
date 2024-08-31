import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Model/VideoDetailsModel.dart';
import 'package:astepup_website/Repository/CourseRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

enum LoadingState { lessonLoading, error, complete }

enum SideBarLoadingState { stage, module, section, complete }

class LessonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LessonController({required this.videoId});
  String courseId = getSavedObject(StorageKeys.courseId) ?? "";
  LoadingState currentState = LoadingState.lessonLoading;
  Rx<bool> enableScroll = true.obs;
  TextEditingController feedBackController = TextEditingController();
  ValueNotifier<String> selectedRoute = ValueNotifier<String>('');
  bool isSideMenuDataLoading = false;
  static Map<String, dynamic> stageDetails =
      getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
  final courseRepository = CourseRepository();
  final textfieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 2, color: borderColorDark));
  bool isFormValid = false;
  final formKey = GlobalKey<FormState>();
  VideoData? videoData;
  final String videoId;
  var uuid = const Uuid();

  @override
  void onInit() async {
    if (videoId.isEmpty &&
        GoRouter.of(rootNavigatorKey.currentContext!)
                .routeInformationProvider
                .value
                .uri
                .toString() ==
            '/lesson') {
      GoRouter.of(rootNavigatorKey.currentContext!).go('/');
    }
    super.onInit();
  }

  changeVideo(String videoId, int currentIndex) async {
    currentState = LoadingState.lessonLoading;
    update();
    await videoDetailsAPI(videoId, currentIndex: currentIndex);
    currentState = LoadingState.complete;
    update();
  }

  feedback() async {
    currentState = LoadingState.lessonLoading;
    update();
    currentState = LoadingState.complete;
    feedBackController.text = '';
    showToast("Feedback submitted successfully");
    update();
  }

  Future<StageDetail?> stageDetailsAPI(String stageId,
      {required String cousreId}) async {
    try {
      isSideMenuDataLoading = true;
      update();
      final stage = await courseRepository.stageDetailsAPI(stageId,
          cousreId: cousreId, updateStorage: true);
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
    } finally {
      isSideMenuDataLoading = false;
      update();
    }
    return null;
  }

  videoDetailsAPI(String videoId, {int currentIndex = 1}) async {
    try {
      currentState = LoadingState.lessonLoading;
      update();
      videoData = await courseRepository.videoDetailsAPI(videoId);
      if (videoData != null) {
        String temp = videoData!.videoName;
        videoData!.videoName = "Lesson $currentIndex : $temp";
        selectedRoute.value = temp;
        currentState = LoadingState.complete;
        update();
      }
    } catch (e) {
      if (e is DioException) {
        currentState = LoadingState.error;
        update();
        print('${e.response?.data}');
      } else {
        print(e.toString());
      }
    }
  }

  Future<ModuleDetails?> moduleDetailsAPI(String moduleid,
      {required String stageId, required String courseId}) async {
    try {
      isSideMenuDataLoading = true;
      update();
      final module = await courseRepository.moduleDetailsAPI(moduleid,
          stageId: stageId, cousreId: courseId, updateStorage: true);
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
    } finally {
      isSideMenuDataLoading = false;
      update();
    }
    return null;
  }

  Future<SectionDetail?> sectionDetailsAPI(String sectionId,
      {String? stageId,
      String? moduleId,
      String? courseId,
      bool avoidLoader = false,
      bool avoidSave = false}) async {
    try {
      if (!avoidLoader) {
        isSideMenuDataLoading = true;
        update();
      }
      final sectionDetail = await courseRepository.sectionDetailsAPI(
          sectionId, moduleId!, stageId!,
          updateStorage: true);
      if (sectionDetail != null) {
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
    } finally {
      isSideMenuDataLoading = false;
      update();
    }
    return null;
  }

  String extractVideoId(String url) {
    RegExp regExp = RegExp(r'vimeo.com\/(\d+)\/([a-zA-Z0-9]+)');
    Match? match = regExp.firstMatch(url);
    if (match != null && match.groupCount == 2) {
      String id = match.group(1)!;
      String hash = match.group(2)!;
      return "$id?h=$hash";
    } else {
      return '';
    }
  }

  Future<String?> updateUserFeedback(
      {required String endPoint, required FormData data}) async {
    try {
      String? message = await courseRepository.updateUserFeedback(
          endPoint: endPoint, data: data);
      if (message != null) {
        feedBackController.clear();
        showToast(message);
      }
    } catch (e) {
      if (e is DioException) {
        currentState = LoadingState.error;
        update();
        if (e.response?.data['message'] is Map<String, dynamic>) {
          Map<String, dynamic> message = e.response?.data['message'];
          debugPrint(message.toString());
        } else {
          debugPrint(e.response?.data);
        }
      } else {
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
