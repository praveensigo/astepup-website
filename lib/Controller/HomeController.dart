import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/HomeModel.dart';
import 'package:astepup_website/Model/HomeSearchModel.dart';

import 'MaintenanceController.dart';

class HomeController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  var isLoading = false.obs;
  List<Course> inprogresscourse = [];
  List<Course> courselist = [];
  String lessonCompletedPercentage = '';
  String quizCompletedPercentage = '';
  String quizCorrectPercentage = '';
  String hoursTotalSpent = '';
  List<HomeSearchModel> searchlist = [];
  // List<HomeSearchModel> searchHistory = [];

  String username = "";
  @override
  void onInit() {
    Get.find<MaintenanceController>().maintenanceAPICall();
    super.onInit();
  }

  Future<void> getHome() async {
    try {
      isLoading(true);
      var url = ApiConfigs.baseUrl + ApiEndPoints.home;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );

      if (response.statusCode == 200) {
        courselist.clear();
        inprogresscourse.clear();
        response.data['data'][0]['my_courses']
            .map((e) => courselist.add(Course.fromJson(e)))
            .toList();
        response.data['data'][0]['in_progress_courses']
            .map((e) => inprogresscourse.add(Course.fromJson(e)))
            .toList();
        username = response.data['data'][0]['user'];
        lessonCompletedPercentage =
            response.data['data'][0]['lesson_completed_percentage'].toString();
        quizCorrectPercentage =
            response.data['data'][0]['quiz_correct_percentage'].toString();
        quizCompletedPercentage =
            response.data['data'][0]['quiz_completed_percentage'].toString();
        hoursTotalSpent = response.data['data'][0]['hours_total_spent'].isEmpty
            ? "0 Hour"
            : response.data['data'][0]['hours_total_spent'];
        update();
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response.toString());
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> homeSearch(String keyword) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.homeSearch;
      var body = {'keyword': keyword};
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        searchlist.clear();
        response.data['data']['user_course']
            .map((e) => searchlist.add(HomeSearchModel.fromJson(e)))
            .toList();
        update();
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      }
    }
  }
}
