import 'dart:convert';

import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'dart:html';

import 'package:astepup_website/Utils/Utils.dart';

class MaintenanceRepository {
  static Future<void> getMaintenanceData() async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.getMaintenanceData;
      HttpRequest result = await HttpRequest.request(url);
      if (result.status == 200) {
        savename(StorageKeys.maintenanceData,
            json.decode(result.responseText ?? ""));
      }
    } catch (e) {
      rethrow;
    }
  }
}
