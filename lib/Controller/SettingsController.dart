import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/AboutModel.dart';
import 'package:astepup_website/Model/CMSModel.dart';
import 'package:astepup_website/Model/ContactModel.dart';
import 'package:astepup_website/Model/FaqModel.dart';
import 'package:astepup_website/Utils/Utils.dart';

class SettingsController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  var isLoading = false.obs;
  CMSData? privacyData;
  CMSData? terms;
  List<FaqModel> faqList = [];
  About? aboutus;
  ContactData? contactData;

  getFaq() async {
    try {
      isLoading(true);
      var url = ApiConfigs.baseUrl + ApiEndPoints.faq;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );

      if (response.statusCode == 200) {
        response.data['data']['faqs']
            .map((e) => faqList.add(FaqModel.fromJson(e)))
            .toList();
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

  getAbout() async {
    try {
      isLoading(true);
      var url = ApiConfigs.baseUrl + ApiEndPoints.aboutus;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        aboutus = About.fromJson(response.data['data']);
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response);
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  getPrivacyPolicy() async {
    try {
      isLoading(true);
      update();
      var url = ApiConfigs.baseUrl + ApiEndPoints.privacyPolicy;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url),
      );
      if (response.statusCode == 200) {
        privacyData = CMSData.fromJson(response.data['data']);
        update();
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  getTermsandCondition() async {
    try {
      isLoading(true);
      update();
      var url = ApiConfigs.baseUrl + ApiEndPoints.terms;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url),
      );
      if (response.statusCode == 200) {
        terms = CMSData.fromJson(response.data['data']);
        update();
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  getContactAPI() async {
    try {
      isLoading(true);
      var url = ApiConfigs.baseUrl + ApiEndPoints.contact;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        contactData = ContactData.fromJson(response.data['data'][0]);
        update();
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    } finally {
      isLoading(false);
      update();
    }
  }
}
