import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Model/VideoDetailsModel.dart';
import 'package:uuid/uuid.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/CourseDetails.dart';
import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../Model/SidebarMenuItemModel.dart';

/*
        depend on course deatils 
        stage:1,
        module:1,
        section:1
        evaluavtion status  1 = pending 2 = complete
        1:yes
        2:no
*/

class CourseRepository {
  var uuid = const Uuid();
  DioInspector inspector = DioInspector(Dio());

  Future<CourseDetails?> courseDetailsAPI(String courseId,
      {bool updateStorage = false}) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.courseDetails;
      var body = {'course_id': courseId};
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is Map) {
          final courseDetails = CourseDetails.fromJson(response.data['data']);
          if (updateStorage) {
            Map<String, dynamic> offlineStorage = {};
            offlineStorage = {
              'course_name': courseDetails.courseName,
              'course_desc': courseDetails.courseDescription,
              'stages': response.data['data']['stages'],
              'course_stage_status': response.data['data']
                  ['course_stage_status'],
              "stage_dependent": courseDetails.stageFlow,
              "module_dependent": courseDetails.moduleFlow,
              "section_dependent": courseDetails.sectionFlow,
              'question_count': courseDetails.questionCount,
              'final_mastery': {
                "id": courseId,
                'course_stage_status': response.data['data']
                    ['course_stage_status'],
                'question_count': courseDetails.questionCount,
                'quiz_key': uuid.v4(),
                "evaluation_status": courseDetails.evaluationStatus,
                "is_quiz_locked": true,
                'is_quiz_complete':
                    (response.data['data']['quiz_result'] ?? 0) == 1
                        ? true
                        : false
              }
            };
            savename(StorageKeys.stageDetails, offlineStorage);
          }
          return courseDetails;
        }
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        debugPrint('couse error:${e.response?.data}');
      } else {
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());
      }
    }
    return null;
  }

  Future<StageDetail?> stageDetailsAPI(
    String stageId, {
    bool updateStorage = false,
    required String cousreId,
  }) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.stageDetails;
      var body = {'stage_id': stageId, 'course_id': cousreId};
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is Map) {
          var stageMap = response.data['data'];
          final stage = StageDetail.fromJson(stageMap);
          if (updateStorage) {
            Map<String, dynamic> offlineStorage =
                getSavedObject(StorageKeys.stageDetails)
                    as Map<String, dynamic>;
            offlineStorage['stages'].forEach((e) {
              if (e['id'].toString() == stageMap['stage_id'].toString()) {
                e['key'] = uuid.v4();
                e['dependent'] = stage.dependent;
                e['module_count'] = stage.moduleCount;
                e['stage_module_status'] = stageMap['stage_module_status'];
                e['is_expanded'] = false;
                e['question_count'] = stage.questionCount;
                e['stage_completed_status'] = stage.stageCompletedStatus;
                e['stage_quiz_completed_status'] =
                    stage.stageQuizCompletedStatus;
                e['is_locked'] = false;
                e['quizResult'] = stage.quizResult;
                e['quiz_key'] = uuid.v4();
                e['is_quiz_locked'] =
                    stage.dependent == 1 && stage.stageCompletedStatus == 2;
                e['is_quiz_complete'] =
                    (response.data['data']['quiz_result'] ?? 0) == 1
                        ? true
                        : false;
                e['stage_description'] = stage.stageDescription;
                e['stage_name'] = stage.stageName;
                e['modules'] = stageMap['modules'];
                e['section_count'] = stage.sectionCount;
              }
            });
            savename(StorageKeys.stageDetails, offlineStorage);
          }
          return stage;
        }
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          debugPrint('Error:$message');
        } else {
          debugPrint('Error:${e.response?.data}');
        }
      }
    }
    return null;
  }

  Future<ModuleDetails?> moduleDetailsAPI(String moduleid,
      {required String stageId,
      required String cousreId,
      bool updateStorage = false}) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.moduleDetails;
      var body = {
        'stage_id': stageId,
        'course_id': cousreId,
        'module_id': moduleid
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is Map) {
          var moduleMap = response.data['data'];
          final module = ModuleDetails.fromJson(moduleMap);
          if (updateStorage) {
            Map<String, dynamic> offlineStorage =
                getSavedObject(StorageKeys.stageDetails)
                    as Map<String, dynamic>;
            offlineStorage['stages'].forEach((e) {
              var stageKey = e['key'];
              if (e['modules'] != null) {
                e['modules'].forEach((e) {
                  if (e['module_id'] == moduleMap['module_id']) {
                    e['key'] = uuid.v4();
                    e['dependent'] = module.dependent;
                    e['parent_key'] = stageKey;
                    e['question_count'] = module.questionCount;
                    e['section_count'] = module.sectionCount;
                    e['module_section_status'] =
                        moduleMap['module_section_status'];
                    e['is_expanded'] = false;
                    e['is_locked'] = false;
                    e['quiz_key'] = uuid.v4();
                    e['is_quiz_complete'] =
                        (response.data['data']['quiz_result'] ?? 0) == 1
                            ? true
                            : false;
                    e['is_quiz_locked'] = module.dependent == 1 &&
                        module.moduleCompletedStatus == 2;
                    e['module_completed_status'] =
                        module.moduleQuizCompletedStatus;
                    e['module_description'] = module.moduleDescription;
                    e['module_quiz_completed_status'] =
                        module.moduleQuizCompletedStatus;
                    e['module_name'] = module.moduleName;
                    e['section_count'] = module.sectionCount;
                    e['quiz_result'] = module.quizResult;
                    e['sections'] = moduleMap['sections'];
                  }
                });
              } else {
                e['modules'] = [];
              }
            });
            savename(StorageKeys.stageDetails, offlineStorage);
          }
          return module;
        }
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          debugPrint('Error:$message');
        } else {
          debugPrint('Error:${e.response?.data}');
        }
      } else {
        debugPrint(e.toString());
      }
    }
    return null;
  }

  Future<SectionDetail?> sectionDetailsAPI(
      String sectionId, String moduleId, String stageId,
      {bool updateStorage = false}) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.sectionDetails;
      var body = {
        "section_id": sectionId,
        'module_id': moduleId,
        'stage_id': stageId,
        'course_id': getSavedObject(StorageKeys.courseId),
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is Map) {
          var sectionMap = response.data['data'];
          final sectionDetail = SectionDetail.fromJson(sectionMap);
          if (updateStorage) {
            Map<String, dynamic> offlineStorage =
                getSavedObject(StorageKeys.stageDetails)
                    as Map<String, dynamic>;
            offlineStorage['stages'].forEach((e) {
              if (e['modules'] != null) {
                e['modules'].forEach((e) {
                  var moduleKey = e['key'];
                  if (e['sections'] != null) {
                    e['sections'].forEach((e) {
                      if (e['section_id'] == sectionMap['section_id']) {
                        e['key'] = uuid.v4();
                        e['parent_key'] = moduleKey;
                        e['is_locked'] = false;
                        e['dependent'] = sectionDetail.dependent;
                        e['lesson_count'] = sectionDetail.lessonCount;
                        e['section_quiz_completed_status'] =
                            sectionDetail.sectionQuizCompletedStatus;
                        e['section_completed_status'] =
                            sectionDetail.sectionCompletedStatus;
                        e['is_expanded'] = false;
                        e['video_count'] = sectionDetail.lessonCount;
                        e['quiz_result'] = sectionDetail.quizResult;
                        e['is_quiz_complete'] =
                            (response.data['data']['quiz_result'] ?? 0) == 1
                                ? true
                                : false;
                        e['is_quiz_locked'] = false;
                        e['section_description'] =
                            sectionDetail.sectionDescription;
                        e['section_name'] = sectionDetail.sectionName;
                        var videoList = sectionMap['videos'].map((video) {
                          video['key'] = uuid.v4();
                          return video;
                        }).toList();
                        e['videos'] = videoList;
                        e['quiz_key'] = uuid.v4();
                        e['question_count'] = sectionMap['question_count'];
                        e['video_status'] = sectionMap['video_status'];
                      }
                    });
                  } else {
                    e['sections'] = [];
                  }
                });
              } else {
                e['modules'] = [];
              }
            });
            savename(StorageKeys.stageDetails, offlineStorage);
          }
          return sectionDetail;
        }
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('section error:${e.response?.data}');
      } else {
        debugPrint(e.toString());
        throw Exception(e);
      }
    }
    return null;
  }

  Future<bool> updateVideoStatus({
    required String stageId,
    required String cousreId,
    required String moduleId,
    required String sectionId,
    required String videoId,
  }) async {
    Map<String, dynamic> offlineStorage =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateVideoStatus;
      var body = {
        "section_id": sectionId,
        "module_id": moduleId,
        "stage_id": stageId,
        "course_id": cousreId,
        "video_id": videoId
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        offlineStorage['stages'].forEach((stage) {
          if (stage['id'].toString() != stageId || stage['modules'] == null) {
            return null;
          }
          stage['modules'].forEach((module) {
            if (module["module_id"].toString() != moduleId ||
                module['sections'] == null) {
              return null;
            }
            module['sections'].forEach((section) {
              if (section["section_id"].toString() != sectionId ||
                  section["video_status"] == null) {
                return null;
              }
              try {
                var video = (section["video_status"] as List).firstWhereOrNull(
                    (video) => video['video_id'].toString() == videoId);
                var videoData = (section["videos"] as List).firstWhereOrNull(
                    (video) => video['video_id'].toString() == videoId);
                if (video != null) {
                  video['watch_status'] = 1;
                  var controller = Get.find<SideMenuManager>();
                  if (controller.initialized) {
                    controller.sideBarController
                        .selectItem(videoData['key'] ?? "");
                    controller.retriveStageDetail(
                        getSavedObject(StorageKeys.stageDetails)['stages'] ??
                            []);
                  }
                  return true;
                }
              } catch (e) {
                debugPrint('error video status $e');
              }
            });
          });
        });
        savename(StorageKeys.stageDetails, offlineStorage);
      }
    } catch (e, stackTace) {
      if (e is DioException) {
        print("error on update video response:\n${e.response?.data}");
      } else {
        print("error on update video:\n${e.toString()}");
        print("error fuction stack trace:\n ${stackTace.toString()}");
      }
    }
    return false;
  }

  void changeQuizLockStatus(
      {String? stageId,
      String? moduleId,
      String? courseId,
      bool quizLockStatus = false}) {
    Map<String, dynamic> offlineStorage =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
    if (courseId != null) {
      offlineStorage['final_mastery']['is_quiz_locked'] = false;
    }
    offlineStorage['stages'].forEach((stage) {
      if (stage['id'].toString() != stageId || stage['modules'] == null) {
        try {
          stage['is_locked'] = false;
          stage['is_quiz_locked'] = quizLockStatus;
        } catch (e) {
          debugPrint('error stage');
        }
        return null;
      }
      if (moduleId != null) {
        stage['modules'].forEach((module) {
          if (module["module_id"].toString() == moduleId) {
            try {
              module['is_locked'] = false;
              module['is_quiz_locked'] = quizLockStatus;
            } catch (e) {
              debugPrint('error in quiz module quiz status');
            }
          }
        });
      }
    });
    savename(StorageKeys.stageDetails, offlineStorage);
  }

  void changeExpandedStatus(
      {String? stageId, String? moduleId, String? sectionId}) {
    Map<String, dynamic> offlineStorage =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
    offlineStorage['stages'].forEach((stage) {
      if (stage['id'].toString() == stageId) {
        try {
          stage['is_expanded'] = true;
        } catch (e) {
          debugPrint('error stage');
        }
      }

      stage['modules'].forEach((module) {
        if (module["module_id"].toString() == moduleId) {
          try {
            module['is_expanded'] = true;
            module['sections'].forEach((section) {
              if (section["section_id"].toString() == sectionId) {
                try {
                  section['is_expanded'] = true;
                } catch (e) {
                  debugPrint('erro occured');
                }
              }
            });
          } catch (e) {
            debugPrint('error in expand module ');
          }
        }
      });
    });
    savename(StorageKeys.stageDetails, offlineStorage);
  }

  String? findElementKey({
    required MenuType type,
    int? stageId,
    int? moduleId,
    int? sectionId,
    int? videoId,
  }) {
    Map<String, dynamic> offlineStorage =
        getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
    for (var stage in offlineStorage['stages']) {
      if (stageId != null && stage['id'] == stageId) {
        if (type == MenuType.stage) {
          return stage['key'];
        }
        if (type == MenuType.stageQuiz) {
          return stage['quiz_key'];
        }

        for (var module in stage['modules']) {
          if (moduleId != null && module['module_id'] == moduleId) {
            if (type == MenuType.module) {
              return module['key'];
            }
            if (type == MenuType.moduleQuiz) {
              return module['quiz_key'];
            }

            for (var section in module['sections']) {
              if (sectionId != null && section['section_id'] == sectionId) {
                if (type == MenuType.section) {
                  return section['key'];
                }
                if (type == MenuType.sectionQuiz) {
                  return section['quiz_key'];
                }

                for (var video in section['videos']) {
                  if (videoId != null && video['video_id'] == videoId) {
                    if (type == MenuType.video) {
                      return video['key'];
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  Future<void> updateUserStageStatus(String stageId) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateUserStageStatus;
      FormData data = FormData.fromMap({
        "course_id": getSavedObject(StorageKeys.courseId),
        "stage_id": stageId,
      });

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        debugPrint('stage updated');
        Map<String, dynamic> offlineStorage =
            getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
        offlineStorage['course_stage_status'].forEach((e) {
          if (e['stage_id'].toString() == stageId) {
            e['completed_status'] = 3;
          }
        });
        offlineStorage['final_mastery']['course_stage_status'].forEach((e) {
          if (e['stage_id'].toString() == stageId) {
            e['completed_status'] = 3;
          }
        });
        savename(StorageKeys.stageDetails, offlineStorage);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> updateUserModuleStatus(String stageId, String moduleId) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateUserModuleStatus;
      FormData data = FormData.fromMap({
        "course_id": getSavedObject(StorageKeys.courseId),
        "stage_id": stageId,
        "module_id": moduleId,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> offlineStorage =
            getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
        offlineStorage['stages'].forEach((e) {
          if (e['id'].toString() == stageId) {
            for (var module in e['stage_module_status']) {
              if (module['module_id'].toString() == moduleId) {
                module['completed_status'] = 3;
                break;
              }
            }
          }
        });
        savename(StorageKeys.stageDetails, offlineStorage);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> updateUserSectionStatus(
      {required String stageId,
      required String moduleId,
      required String sectionId}) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateUserSection;
      FormData data = FormData.fromMap({
        "course_id": getSavedObject(StorageKeys.courseId),
        "stage_id": stageId,
        "module_id": moduleId,
        "section_id": sectionId,
      });

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> offlineStorage =
            getSavedObject(StorageKeys.stageDetails) as Map<String, dynamic>;
        offlineStorage['stages'].forEach((e) {
          if (e['id'].toString() == stageId) {
            if (e['modules'] != null) {
              e['modules'].forEach((e) {
                if (e['module_id'].toString() == moduleId) {
                  for (var section in e['module_section_status']) {
                    if (section['section_id'].toString() == sectionId) {
                      section['completed_status'] = 3;
                      break;
                    }
                  }
                }
              });
            }
          }
        });
        savename(StorageKeys.stageDetails, offlineStorage);
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data.toString());
      } else {
        debugPrint('update sectio:${e.toString()}');
      }
    }
  }

  Future<void> updateUserCourseStatus(String courseId) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.updateUserCourseStatus;
      FormData data = FormData.fromMap({
        "course_id": courseId,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        debugPrint("course status:${response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        debugPrint(e.toString());
      }
    }
  }

  Future<VideoData?> videoDetailsAPI(String videoId,
      {int currentIndex = 1}) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.videoDetails;
      var body = {'video_id': videoId};
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        return VideoData.fromJson(response.data['data'][0]);
      }
    } catch (e) {
      if (e is DioException) {
        print('${e.response?.data}');
      } else {
        print(e.toString());
      }
    }
    return null;
  }

  Future<String?> updateUserFeedback(
      {required String endPoint, required FormData data}) async {
    try {
      var url = ApiConfigs.baseUrl + endPoint;

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: data),
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map<String, dynamic>) {
          Map<String, dynamic> message = e.response?.data['message'];
          debugPrint(message.toString());
        } else {
          print(e.response?.data.toString());
        }
      } else {
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
