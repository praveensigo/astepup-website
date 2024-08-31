import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/EvaluationSurvayModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';

class EvaluationSurveyController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  var isLoading = false.obs;
  String optionId = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<EvaluationSurveyModel> choices = [];
  List<Map<String, dynamic>> dataArray = [];
  TextEditingController openioncontroller = TextEditingController();
  List<TextEditingController> opinionTextController = [];
  int? evaluationId;

  evaluationSurvey() async {
    try {
      isLoading(true);
      update();
      var url = ApiConfigs.baseUrl + ApiEndPoints.evaluationSurvey;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        choices.clear();
        response.data['data']
            .map((e) => choices.add(EvaluationSurveyModel.fromJson(e)))
            .toList();
        update();
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<bool> addEvaluation(
    BuildContext context,
  ) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.addEvaluationSurvey;
      var body = FormData.fromMap({
        "evaluations": jsonEncode(dataArray),
        "course_id": getSavedObject(StorageKeys.courseId)
      });
      print(jsonEncode(dataArray));
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        showToast(response.data['message']);
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          showErrorToast(message);
        } else {
          showSnackBar(msg: e.response?.data['message'], context: context);
        }
      }
    } finally {
      dataArray.clear();
    }

    return false;
  }
}
