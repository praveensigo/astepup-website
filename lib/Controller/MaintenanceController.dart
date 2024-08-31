import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/MaintenanceData.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

class MaintenanceController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  MaintenanceData? maintanceSettings;

  @override
  void onInit() {
    maintenanceAPICall();
    super.onInit();
  }

  maintenanceAPICall() async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.maintenance;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          maintanceSettings = MaintenanceData.fromJson(response.data['data']);
          if (maintanceSettings != null &&
              maintanceSettings!.maintenanceWeb == 1) {
            if (rootNavigatorKey.currentContext != null) {
              GoRouter.of(rootNavigatorKey.currentContext!)
                  .pushReplacement('/maintenance');
            }
          } else {
            if (rootNavigatorKey.currentContext != null) {
              if (GoRouter.of(rootNavigatorKey.currentContext!)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString()
                  .contains("/maintenance")) {
                var token = await getSavedObject('token');
                if (token == null) {
                  GoRouter.of(rootNavigatorKey.currentContext!)
                      .pushReplacement('/login');
                } else {
                  GoRouter.of(rootNavigatorKey.currentContext!)
                      .pushReplacement('/');
                }
              }
            }
          }
          return;
        }
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        print('maintanc error' + e.response!.data.toString());
      } else {
        print('maintanc error' + e.toString());
        print(stackTrace.toString());
      }
    }
  }
}
