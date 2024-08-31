import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../Config/ApiConfig.dart';

class QuizRepository {
  String? courseId = getSavedObject(StorageKeys.courseId) ?? "";
  DioInspector inspector = DioInspector(Dio());

  Future<bool> quizValidationAPI(
      {BuildContext? context,
      required FormData formdata,
      required String endpoint}) async {
    try {
      if (context != null) {
        showLoader(context);
      }
      var url = ApiConfigs.baseUrl + endpoint;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: formdata),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      }
    }
    return false;
  }

  Future<Response?> quizDetailsAPI(
      {Map<String, dynamic>? body, required String endPoints}) async {
    try {
      var url = ApiConfigs.baseUrl + endPoints;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e, stacktrace) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        debugPrint("error in section quiz${e.toString()}");
        debugPrint("error in section quiz${stacktrace.toString()}");
      }
    }
    return null;
  }

  Future<void> updateSectionQuizStatus({
    required String sectionid,
    required String stageid,
    required String moduleid,
    required String courseid,
    required String currentquizPercentage,
  }) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateSectionPercentage;
      FormData data = FormData.fromMap({
        "course_id": courseid,
        "section_id": sectionid,
        "module_id": moduleid,
        "stage_id": stageid,
        "quiz_correct_percentage": currentquizPercentage
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      debugPrint(response.data);
      if (response.statusCode == 200) {
        debugPrint("section quiz update:${response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("section quiz update error :${e.response?.data}");
        if (e.response?.data['message'] is Map) {
          print(e.response?.data);
        } else {
          // showToast(e.response?.data['message']);
        }
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> updateModuleQuizStatus({
    required String courseId,
    required String stageId,
    required String moduleId,
    required String currentquizPercentage,
  }) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateModuleQuiz;
      FormData data = FormData.fromMap({
        "course_id": courseId,
        "stage_id": stageId,
        "module_id": moduleId,
        "quiz_correct_percentage": currentquizPercentage
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {}
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          print(e.response?.data);
        } else {
          // showToast(e.response?.data['message']);
        }
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> updateStageQuizStatus({
    required String courseId,
    required String stageId,
    required String currentquizPercentage,
  }) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateStageQuiz;
      FormData data = FormData.fromMap({
        "course_id": courseId,
        "stage_id": stageId,
        "quiz_correct_percentage": currentquizPercentage
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        debugPrint("stage quiz update:${response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("stage quiz update error :${e.response?.data}");
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> updateCourseQuizStatus({
    required String courseId,
    required String currentquizPercentage,
  }) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateCourseQuiz;
      FormData data = FormData.fromMap({
        "course_id": courseId,
        "quiz_correct_percentage": currentquizPercentage
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        debugPrint("course quiz update:${response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("stage quiz update error :${e.response?.data}");
        if (e.response?.data['message'] is Map) {
        } else {
          // showToast(e.response?.data['message']);
        }
      } else {
        debugPrint(e.toString());
      }
    }
  }
}
