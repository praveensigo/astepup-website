import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/ContributorModel.dart';

import '../ApiClient/ApiClient.dart';

class ContributorsController extends GetxController {
  var isLoading = false;
  DioInspector inspector = DioInspector(Dio());
  List<Datum> contributorList = [];

  getContributors() async {
    isLoading = true;
    update();
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.contributors;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        isLoading = false;
        ContributorModel contributorModel =
            ContributorModel.fromJson(response.data);
        contributorList = contributorModel.data;
        update();
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
