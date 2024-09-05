import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:go_router/go_router.dart';

import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Model/CourseDetails.dart';
import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/QuestionExplanationModel.dart';
import 'package:astepup_website/Model/QuizDetailModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Repository/CourseRepository.dart';
import 'package:astepup_website/Repository/QuizRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

class QuizController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  var isLoading = false.obs;
  SectionDetail? sectionDetail;
  StageDetail? stagedetail;
  static Map<String, dynamic> stageDetails =
      getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
  final courseRepository = CourseRepository();
  final quizRepository = QuizRepository();
  List<Question> questionlist = [];
  Map<String, dynamic> questionListDB = {};
  String errorMessage = "";
  String? optionid = '';
  String stagename = '';
  CourseDetails? courseDetails;
  String courseName = '';
  String sectionName = '';
  String sectionId = '';
  String vid = '';

  String moduleName = '';
  ModuleDetails? moduleDetails;
  String quizPercetage = "0";
  @override
  void onInit() {
    var quizPercentageValue = getSavedObject(StorageKeys.quizPercentage);
    if (quizPercentageValue is String) {
      quizPercetage = quizPercentageValue;
    } else {
      quizPercetage = quizPercentageValue.toString();
    }
    super.onInit();
  }

  clearCurrentData() {
    optionid = null;
    removename(StorageKeys.quizPercentage);
    quizPercetage = "0";
    errorMessage = '';
    questionlist.clear();
  }

  @override
  void dispose() {
    removename(StorageKeys.stageId);
    removename(StorageKeys.moduleId);
    removename(StorageKeys.sectionId);
    super.dispose();
  }

///////////////////////////////////stage/////////////////////////////////
  stageQuizDetail(String stageId, String courseId) async {
    try {
      isLoading(true);
      update();
      var body = {
        'stage_id': stageId,
        "course_id": courseId,
      };
      Response? response = await quizRepository.quizDetailsAPI(
          body: body, endPoints: ApiEndPoints.stageQuizDetail);
      if (response?.statusCode == 200) {
        Map<String, dynamic> currentQuizData = {};
        questionlist.clear();
        response?.data['data'][0]['questions']
            .map((e) => questionlist.add(Question.fromJson(e)))
            .toList();
        if (questionlist.isNotEmpty) {
          currentQuizData['quiz_title'] =
              response?.data['data'][0]['stage_name'];
          currentQuizData['quiz_decs'] =
              response?.data['data'][0]['stage_description'];
          currentQuizData['quiz_id'] = response?.data['data'][0]['stage_id'];
          currentQuizData['quiz_quizCound'] =
              response?.data['data'][0]['no_of_question'];
          currentQuizData['quiz_criteria'] =
              response?.data['data'][0]['quiz_criteria'];
          savename(StorageKeys.quizData, currentQuizData);
        }
        stagename = response?.data['data'][0]['stage_name'];
        questionListDB['quiz'] = questionlist.map((e) => e.toJson()).toList();
        savename(StorageKeys.quizList, questionListDB);
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

  Future<bool> stagequizValidation(String stageId, String questionId) async {
    try {
      isLoading(true);
      var body = FormData.fromMap({
        "choice_id": optionid,
        "question_id": questionId,
        "stage_id": stageId,
      });
      var response = await quizRepository.quizValidationAPI(
          formdata: body, endpoint: ApiEndPoints.stagequizValidation);
      if (response) {
        optionid = null;
        errorMessage = "";
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        var responseData = e.response!.data;
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          var firstData = responseData['data'][0];
          if (firstData['message'] != null) {
            if (firstData['correct option'] != null) {
              optionid = null;
              errorMessage = '${firstData['correct option'][0]['choice']}';
              update();
            }
          }
        }
      }
    } finally {
      isLoading(false);
      update();
    }

    return false;
  }

  Future<void> stageDetailsAPI(String stageId, String courseid) async {
    try {
      clearCurrentData();
      isLoading(true);
      update();
      stagedetail =
          await courseRepository.stageDetailsAPI(stageId, cousreId: courseid);
      if (stagedetail != null) {
        Map<String, dynamic> currentQuizData = {};
        if (stagedetail != null) {
          currentQuizData['quiz_title'] = stagedetail!.stageName;
          currentQuizData['quiz_decs'] = stagedetail!.stageDescription;
          currentQuizData['quiz_id'] = stagedetail!.stageId;
          currentQuizData['question_count'] = stagedetail!.questionCount;
        }
        savename(StorageKeys.quizData, currentQuizData);
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }
  //////////////////////////course//////////////////////////////////////////////////

  Future<void> courseDetailsApi(String courseId) async {
    try {
      clearCurrentData();
      isLoading(true);
      update();
      courseDetails = await courseRepository.courseDetailsAPI(courseId);
      Map<String, dynamic> currentQuizData = {};
      if (courseDetails != null) {
        currentQuizData['quiz_title'] = courseDetails!.courseName;
        currentQuizData['quiz_decs'] = courseDetails!.courseDescription;
        currentQuizData['quiz_id'] = courseId.toString();
        currentQuizData['question_count'] = courseDetails!.questionCount;
        savename(StorageKeys.quizData, currentQuizData);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('res:${e.response?.data}');
        Map<String, dynamic> message = e.response?.data['message'];
        showErrorToast(message);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  courseQuizDetail(String courseId) async {
    try {
      isLoading(true);
      update();
      var body = {'course_id': getSavedObject(StorageKeys.courseId)};
      var response = await quizRepository.quizDetailsAPI(
          endPoints: ApiEndPoints.courseQuizzDetails, body: body);
      if (response?.statusCode == 200) {
        Map<String, dynamic> currentQuizData = {};
        questionlist.clear();
        response?.data['data'][0]['questions']
            .map((e) => questionlist.add(Question.fromJson(e)))
            .toList();
        if (questionlist.isNotEmpty) {
          currentQuizData['quiz_title'] =
              response?.data['data'][0]['course_name'];
          currentQuizData['quiz_decs'] =
              response?.data['data'][0]['course_description'];
          currentQuizData['quiz_id'] = response?.data['data'][0]['course_id'];
          currentQuizData['quiz_quizCound'] =
              response?.data['data'][0]['no_of_question'];
          currentQuizData['quiz_criteria'] =
              response?.data['data'][0]['quiz_criteria'];
          savename(StorageKeys.quizData, currentQuizData);
        }
        questionListDB['quiz'] = questionlist.map((e) => e.toJson()).toList();
        savename(StorageKeys.quizList, questionListDB);
        courseName = response?.data['data'][0]['course_name'];
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

  Future<bool> coursequizValidation(String courseId, String questionId) async {
    try {
      isLoading(true);
      var body = FormData.fromMap({
        "choice_id": optionid,
        "question_id": questionId,
        "course_id": courseId,
      });
      var response = await quizRepository.quizValidationAPI(
          formdata: body, endpoint: ApiEndPoints.courseQuizzValidation);
      if (response) {
        optionid = null;
        errorMessage = "";
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        var responseData = e.response!.data;
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          var firstData = responseData['data'][0];
          if (firstData['message'] != null) {
            if (firstData['correct option'] != null) {
              optionid = null;
              errorMessage = '${firstData['correct option'][0]['choice']}';
              update();
            }
          }
        }
      }
    } finally {
      isLoading(false);
      update();
    }
    return false;
  }
  ///////////////////////////////////section/////////////////////////////

  sectionDetailsAPI(String sectionId,
      {required String moduleid,
      required String stageId,
      required String courseId}) async {
    clearCurrentData();
    try {
      isLoading(true);
      update();
      sectionDetail = await courseRepository.sectionDetailsAPI(
          sectionId, moduleid, stageId);
      if (sectionDetail != null) {
        Map<String, dynamic> currentQuizData = {};
        if (sectionDetail != null) {
          currentQuizData['quiz_title'] = sectionDetail!.sectionName;
          currentQuizData['quiz_decs'] = sectionDetail!.sectionDescription;
          currentQuizData['quiz_id'] = sectionDetail!.sectionId;
          currentQuizData['quiz_quizCound'] = sectionDetail!.questionCount;
          vid = sectionDetail!.videos.first.videoId.toString();
        }
        savename(StorageKeys.quizData, currentQuizData);
        isLoading(false);
        update();
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response!.data);
        isLoading(false);
        update();
      } else {
        print(e.toString());
      }
    }
  }

  sectionQuizDetail(String sectionid, String courseId) async {
    try {
      isLoading(true);
      update();
      var body = {
        'section_id': sectionid,
        "course_id": courseId,
      };
      var response = await quizRepository.quizDetailsAPI(
          endPoints: ApiEndPoints.sectionQuizDetail, body: body);
      if (response?.statusCode == 200) {
        Map<String, dynamic> currentQuizData = {};
        questionlist.clear();
        response?.data['data'][0]['questions']
            .map((e) => questionlist.add(Question.fromJson(e)))
            .toList();
        if (questionlist.isNotEmpty) {
          currentQuizData['quiz_title'] =
              response?.data['data'][0]['section_name'];
          currentQuizData['quiz_decs'] =
              response?.data['data'][0]['section_description'];
          currentQuizData['quiz_id'] = response?.data['data'][0]['section_id'];
          currentQuizData['quiz_quizCound'] =
              response?.data['data'][0]['no_of_question'];
          currentQuizData['quiz_criteria'] =
              response?.data['data'][0]['quiz_criteria'];
          savename(StorageKeys.quizData, currentQuizData);
        }
        sectionName = response!.data['data'][0]['section_name'].toString();
        sectionId = response.data['data'][0]['section_id'].toString();
        questionListDB['quiz'] = questionlist.map((e) => e.toJson()).toList();
        savename(StorageKeys.quizList, questionListDB);
        update();
      }
    } catch (e, stacktrace) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        debugPrint("error in section quiz${e.toString()}");
        debugPrint("error in section quiz${stacktrace.toString()}");
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<bool> sectionquizValidation(
      BuildContext context, String sectionId, String questionId) async {
    try {
      var body = FormData.fromMap({
        "choice_id": optionid,
        "question_id": questionId,
        "section_id": sectionId,
      });
      var response = await quizRepository.quizValidationAPI(
          context: context,
          formdata: body,
          endpoint: ApiEndPoints.quizValidation);
      if (response) {
        optionid = null;
        errorMessage = "";
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        var responseData = e.response!.data;
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          var firstData = responseData['data'][0];
          if (firstData['message'] != null) {
            optionid = null;
            if (firstData['correct option'] != null) {
              errorMessage = '${firstData['correct option'][0]['choice']}';
              update();
            }
          }
        }
      }
    }
    return false;
  }

/////////////////////////////////////////////module////////////////////////////////////////

  Future<void> moduleDetailsAPI(
      String moduleid, String stageId, String courseId) async {
    clearCurrentData();
    try {
      isLoading(true);
      update();
      moduleDetails = await courseRepository.moduleDetailsAPI(moduleid,
          stageId: stageId, cousreId: courseId);
      if (moduleDetails != null) {
        Map<String, dynamic> currentQuizData = {};
        if (moduleDetails != null) {
          currentQuizData['quiz_title'] = moduleDetails!.moduleName;
          currentQuizData['quiz_decs'] = moduleDetails!.moduleDescription;
          currentQuizData['quiz_id'] = moduleDetails!.moduleId.toString();
          currentQuizData['quiz_quizCound'] = moduleDetails!.questionCount;
          sectionId = moduleDetails!.sections.first.sectionId.toString();
        }
        savename(StorageKeys.quizData, currentQuizData);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint(e.response!.data);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  moduleQuizDetail(String moduleId, String courseId) async {
    optionid = null;
    try {
      isLoading(true);
      update();
      var body = {
        'module_id': moduleId,
        "course_id": courseId,
      };
      var response = await quizRepository.quizDetailsAPI(
          endPoints: ApiEndPoints.moduleQuizDetail, body: body);
      if (response?.statusCode == 200) {
        Map<String, dynamic> currentQuizData = {};
        questionlist.clear();
        response?.data['data'][0]['questions']
            .map((e) => questionlist.add(Question.fromJson(e)))
            .toList();
        if (questionlist.isNotEmpty) {
          currentQuizData['quiz_title'] =
              response?.data['data'][0]['module_name'];
          currentQuizData['quiz_decs'] =
              response?.data['data'][0]['module_description'];
          currentQuizData['quiz_id'] = response?.data['data'][0]['module_id'];
          currentQuizData['quiz_quizCound'] =
              response?.data['data'][0]['no_of_question'];
          currentQuizData['quiz_criteria'] =
              response?.data['data'][0]['quiz_criteria'];
          savename(StorageKeys.quizData, currentQuizData);
        }
        moduleName = response?.data['data'][0]['module_name'];
        questionListDB['quiz'] = questionlist.map((e) => e.toJson()).toList();
        savename(StorageKeys.quizList, questionListDB);
        update();
      }
    } catch (e, stacktrace) {
      if (e is DioException) {
        print(e.response?.data.toString());
      } else {
        print(e.toString());
        print(stacktrace.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<bool> modulequizValidation(
      BuildContext context, String moduleid, String questionId) async {
    try {
      var body = FormData.fromMap({
        "choice_id": optionid,
        "question_id": questionId,
        "module_id": moduleid,
      });
      var response = await quizRepository.quizValidationAPI(
          context: context,
          formdata: body,
          endpoint: ApiEndPoints.moduleQuizValidation);
      if (response) {
        optionid = null;
        errorMessage = "";
        return true;
      }
    } catch (e) {
      if (e is DioException) {
        var responseData = e.response?.data;
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          var firstData = responseData['data'][0];
          if (firstData['message'] != null) {
            if (firstData['correct option'] != null) {
              optionid = null;
              errorMessage = '${firstData['correct option'][0]['choice']}';
              update();
            }
          }
        }
      }
    }
    return false;
  }

  Future<QuizExplainModel?> answerExplanationAPI(String qid) async {
    isLoading(true);
    update();
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.questionExplanation;
      var body = {'question_id': qid};
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        return QuizExplainModel.fromJson(response.data['data'][0]);
      }
    } catch (e) {
      if (e is DioException) {
        Map<String, dynamic> message = e.response?.data['message'];
        showErrorToast(message);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
    return null;
  }

  Future<String?> nextSectionApi(String sectionid, String stageid,
      String courseid, String moduleid, BuildContext context) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.nextSection;
      var body = {
        "section_id": sectionid,
        "module_id": moduleid,
        "stage_id": stageid,
        "course_id": courseid
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        var lessonController = Get.find<LessonController>();
        Map<String, dynamic> data =
            getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
        if (response.data['data'] is Map<String, dynamic>) {
          if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next_section")) {
            await sectionDetailsAPI(
                response.data['data']['next_section'].toString(),
                stageId: stageid,
                courseId: courseid,
                moduleid: moduleid);
            lessonController.changeVideo(vid, 1);
            courseRepository.updateVideoStatus(
                stageId: stageid,
                cousreId: courseid,
                moduleId: moduleid,
                sectionId: response.data['data']['next_section'].toString(),
                videoId: vid);
            savename(StorageKeys.videoId, vid);
            savename(StorageKeys.lessonIndex, 1);
            if (context.mounted) {
              clearBackNavigationStack(
                  context: context,
                  title: "details",
                  currentPath: "/detail/$courseid",
                  nextPath: '/lesson',
                  extra: {
                    "vid": vid,
                  });
            }
            return 'none';
          } else if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next")) {
            Map<String, dynamic>? module =
                Get.find<SideMenuManager>().getModuleById(moduleid);
            if (module != null && (module['question_count'] ?? 0) > 0) {
              return null;
            } else {
              courseRepository.updateUserModuleStatus(stageid, moduleid);
            }
            var nextModuleId =
                response.data["data"]["next"]["module_id"].toString();
            var nextStageId =
                response.data["data"]["next"]["stage_id"].toString();
            var nextCourseId =
                response.data["data"]["next"]["course_id"].toString();
            var nextSectionId =
                response.data["data"]["next"]["section_id"].toString();
            await sectionDetailsAPI(nextSectionId,
                stageId: nextStageId,
                courseId: nextCourseId,
                moduleid: nextModuleId);
            lessonController.changeVideo(vid, 1);
            courseRepository.updateVideoStatus(
                stageId: nextStageId,
                cousreId: courseid,
                moduleId: nextModuleId,
                sectionId: nextSectionId,
                videoId: vid);
            if (context.mounted) {
              clearBackNavigationStack(
                  context: context,
                  title: "details",
                  currentPath: "/detail/$courseid",
                  nextPath: '/lesson',
                  extra: {
                    "vid": vid,
                  });
            }
            savename(StorageKeys.videoId, vid);
            savename(StorageKeys.lessonIndex, 1);
            return 'none';
          }
        } else if (response.data['message'] == 'Course completed') {
          var finalmastery = data['final_mastery'];
          if (finalmastery['evaluation_status'] == '2') {
            GoRouter.of(rootNavigatorKey.currentContext!).go('/certificate');
          } else {
            GoRouter.of(rootNavigatorKey.currentContext!)
                .go('/evaluation-survey');
          }
        }
      }
    } catch (e) {
      if (e is DioException) {
        Map<String, dynamic> message = e.response?.data['message'];
        showErrorToast(message);
      } else {
        print('next api seciton:${e.toString()}');
      }
    }
    return null;
  }

  Future<String?> nextModuleApi(String moduleId, String stageId,
      String courseId, BuildContext context) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.nextModuleApi;
      var body = {
        "course_id": courseId,
        "stage_id": stageId,
        "module_id": moduleId,
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] is Map<String, dynamic>) {
          if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next_module")) {
            var lessonController = Get.find<LessonController>();
            var nextModuleId = response.data['data']['next_module'].toString();
            var moduleDeatils = await lessonController.moduleDetailsAPI(
                nextModuleId.toString(),
                stageId: stageId,
                courseId: courseId);
            var sectionId = moduleDeatils?.sections.firstOrNull?.sectionId;
            if (sectionId != null) {
              var sectionDeatils = await lessonController.sectionDetailsAPI(
                  sectionId.toString(),
                  moduleId: nextModuleId,
                  stageId: stageId,
                  courseId: courseId,
                  avoidSave: true);
              if (sectionDeatils != null) {
                var videoIdfromApi =
                    sectionDeatils.videos.firstOrNull?.videoId.toString();
                if (videoIdfromApi != null) {
                  savename(StorageKeys.videoId, videoIdfromApi);
                  savename(StorageKeys.lessonIndex, 1);
                  if (context.mounted) {
                    lessonController.changeVideo(videoIdfromApi, 1);
                    courseRepository.updateVideoStatus(
                        stageId: stageId,
                        cousreId: courseId,
                        moduleId: nextModuleId.toString(),
                        sectionId: sectionId.toString(),
                        videoId: videoIdfromApi);
                    if (context.mounted) {
                      clearBackNavigationStack(
                          context: context,
                          title: "details",
                          currentPath: "/detail/$courseId",
                          nextPath: '/lesson',
                          extra: {
                            "vid": videoIdfromApi,
                          });
                    }
                  }
                }
              }
            }
            return 'none';
          }
          if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next")) {
            var nextModuleId =
                response.data["data"]["next"]["module_id"].toString();
            var nextStageId =
                response.data["data"]["next"]["stage_id"].toString();
            var nextCourseId =
                response.data["data"]["next"]["course_id"].toString();
            var lessonController = Get.find<LessonController>();
            var moduleDeatils = await lessonController.moduleDetailsAPI(
                nextModuleId.toString(),
                stageId: nextStageId,
                courseId: nextCourseId);
            var sectionId = moduleDeatils?.sections.firstOrNull?.sectionId;
            if (sectionId != null) {
              var sectionDeatils = await lessonController.sectionDetailsAPI(
                  sectionId.toString(),
                  moduleId: nextModuleId,
                  stageId: nextStageId,
                  courseId: nextCourseId,
                  avoidSave: true);
              if (sectionDeatils != null) {
                var videoIdfromApi =
                    sectionDeatils.videos.firstOrNull?.videoId.toString();
                if (videoIdfromApi != null) {
                  savename(StorageKeys.videoId, videoIdfromApi);
                  savename(StorageKeys.lessonIndex, 1);
                  if (context.mounted) {
                    lessonController.changeVideo(videoIdfromApi, 1);
                    courseRepository.updateVideoStatus(
                        stageId: nextStageId,
                        cousreId: nextCourseId,
                        moduleId: nextModuleId.toString(),
                        sectionId: sectionId.toString(),
                        videoId: videoIdfromApi);
                    if (context.mounted) {
                      clearBackNavigationStack(
                          context: context,
                          title: "details",
                          currentPath: "/detail/$courseId",
                          nextPath: '/lesson',
                          extra: {
                            "vid": videoIdfromApi,
                          });
                    }
                  }
                }
              }
            }
            return 'none';
          }
        } else if (response.data['message'] == 'Course completed') {
          Map<String, dynamic> data = getSavedObject(StorageKeys.stageDetails);
          data['stages'].forEach((stage) {
            if (stage['id'].toString() == stageId) {
              try {
                stage['modules'].forEach((module) {
                  if (module["module_id"].toString() == moduleId) {
                    try {
                      if ((stage['question_count'] ?? 0) > 0) {
                        var selectedKey = stage['key'];
                        GoRouter.of(context).go('/lesson/stage/$courseId',
                            extra: {
                              'cid': courseId,
                              'selectedKey': selectedKey
                            });
                      } else if ((data['final_mastery']['question_count'] ?? 0) >
                          0) {
                        var selectedKey = data['final_mastery']['key'] ?? "";
                        GoRouter.of(context).go(
                            '/lesson/mastery/${getSavedObject(StorageKeys.courseId)}',
                            extra: {'selectedKey': selectedKey});
                      } else {
                        var finalmastery = data['final_mastery'];
                        if (finalmastery['evaluation_status'] == '2') {
                          GoRouter.of(context).go('/certificate');
                        } else {
                          GoRouter.of(context).go('/evaluation-survey');
                        }
                      }
                    } catch (e) {
                      debugPrint('error next  module api');
                    }
                  }
                });
              } catch (e) {
                debugPrint('error stage');
              }
              return null;
            }
          });
        }
      }
    } catch (e) {
      if (e is DioException) {
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

  Future<String?> nextStageApi(
      String stageId, String courseId, BuildContext context) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.nextStageApi;
      var body = {
        "course_id": courseId,
        "stage_id": stageId,
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] is Map<String, dynamic>) {
          if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next_stage")) {
            var lessonController = Get.find<LessonController>();
            final nextStageId = response.data['data']['next_stage'].toString();
            var stageDetails = await lessonController
                .stageDetailsAPI(nextStageId, cousreId: courseId);
            var nextModuleId = stageDetails?.modules.firstOrNull?.moduleId;
            if (nextModuleId != null) {
              var moduleDeatils = await lessonController.moduleDetailsAPI(
                  nextModuleId.toString(),
                  stageId: nextStageId,
                  courseId: courseId);
              var sectionId = moduleDeatils?.sections.firstOrNull?.sectionId;
              if (sectionId != null) {
                var sectionDeatils = await lessonController.sectionDetailsAPI(
                    sectionId.toString(),
                    moduleId: nextModuleId.toString(),
                    stageId: nextStageId,
                    courseId: courseId,
                    avoidSave: true);
                if (sectionDeatils != null) {
                  var videoIdfromApi =
                      sectionDeatils.videos.firstOrNull?.videoId.toString();
                  if (videoIdfromApi != null) {
                    savename(StorageKeys.videoId, videoIdfromApi);
                    savename(StorageKeys.lessonIndex, 1);
                    lessonController.changeVideo(videoIdfromApi, 1);
                    courseRepository.updateVideoStatus(
                        stageId: nextStageId,
                        cousreId: courseId,
                        moduleId: nextModuleId.toString(),
                        sectionId: sectionId.toString(),
                        videoId: videoIdfromApi);
                    if (context.mounted) {
                      clearBackNavigationStack(
                          context: context,
                          title: "details",
                          currentPath: "/detail/$courseId",
                          nextPath: '/lesson',
                          extra: {
                            "vid": videoIdfromApi,
                          });
                    }
                  }
                }
              }
            }
          }
          if ((response.data['data'] as Map<String, dynamic>)
              .containsKey("next")) {
            var lessonController = Get.find<LessonController>();
            final nextStageId =
                response.data['data']['next']['stage_id'].toString();
            var stageDetails = await lessonController
                .stageDetailsAPI(nextStageId, cousreId: courseId);
            var nextModuleId = stageDetails?.modules.firstOrNull?.moduleId;
            if (nextModuleId != null) {
              var moduleDeatils = await lessonController.moduleDetailsAPI(
                  nextModuleId.toString(),
                  stageId: nextStageId,
                  courseId: courseId);
              var sectionId = moduleDeatils?.sections.firstOrNull?.sectionId;
              if (sectionId != null) {
                var sectionDeatils = await lessonController.sectionDetailsAPI(
                    sectionId.toString(),
                    moduleId: nextModuleId.toString(),
                    stageId: nextStageId,
                    courseId: courseId,
                    avoidSave: true);
                if (sectionDeatils != null) {
                  var videoIdfromApi =
                      sectionDeatils.videos.firstOrNull?.videoId.toString();
                  if (videoIdfromApi != null) {
                    savename(StorageKeys.videoId, videoIdfromApi);
                    savename(StorageKeys.lessonIndex, 1);
                    lessonController.changeVideo(videoIdfromApi, 1);
                    courseRepository.updateVideoStatus(
                        stageId: nextStageId,
                        cousreId: courseId,
                        moduleId: nextModuleId.toString(),
                        sectionId: sectionId.toString(),
                        videoId: videoIdfromApi);
                    if (context.mounted) {
                      clearBackNavigationStack(
                          context: context,
                          title: "details",
                          currentPath: "/detail/$courseId",
                          nextPath: '/lesson',
                          extra: {
                            "vid": videoIdfromApi,
                          });
                    }
                  }
                }
              }
            }
            return 'none';
          }
        } else if (response.data['message'] == 'Course completed') {
          Map<String, dynamic> data = getSavedObject(StorageKeys.stageDetails);
          if ((data['final_mastery']['question_count'] ?? 0) > 0) {
            if (context.mounted) {
              var selectedKey = data['final_mastery']['key'] ?? "";
              GoRouter.of(context).go(
                  '/lesson/mastery/${getSavedObject(StorageKeys.courseId)}',
                  extra: {'selectedKey': selectedKey});
            }
          } else {
            var finalmastery = data['final_mastery'];
            if (finalmastery['evaluation_status'] == '2') {
              if (context.mounted) {
                savename("courseName", data['course']);
                GoRouter.of(context).go('/certificate');
              }
            } else {
              if (context.mounted) {
                GoRouter.of(context).go('/evaluation-survey');
              }
            }
          }
        }
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        print(e.toString());
      }
    }
    return null;
  }

  List<dynamic> getRandomQuiz<T>(List<dynamic> list, int count) {
    final random = Random();
    final length = list.length;

    if (length <= count) {
      return list;
    } else {
      final selectedIndices = <int>{};
      while (selectedIndices.length < count) {
        final index = random.nextInt(length);
        selectedIndices.add(index);
      }
      return selectedIndices.map((index) => list[index]).toList();
    }
  }
}
