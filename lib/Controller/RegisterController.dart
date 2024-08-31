import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/CountrycodeModel.dart';
import 'package:astepup_website/Model/UserData.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController {
  final confirmPasswordController = TextEditingController();
  List<CountryCode> countryCodes = [];
  final emailController = TextEditingController();
  DioInspector inspector = DioInspector(Dio());
  bool isLoading = false;
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  CountryCode? selectedCountryCode;
  final uniqueCodeController = TextEditingController();
  String? uniqueCodeError;

  @override
  void dispose() {
    uniqueCodeController.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    getCountryCode();
    super.onInit();
  }

  getCountryCode() async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.getCountryCodes;
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url),
      );
      if (response.statusCode == 200) {
        response.data['data']['country_codes']
            .map((e) => countryCodes.add(CountryCode.fromJson(e)))
            .toList();
        if (countryCodes.isNotEmpty) {
          selectedCountryCode = countryCodes.first;
        }
        update();
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    }
  }

  completeProfileAPI(BuildContext context) async {
    try {
      showLoader(context);
      var url = ApiConfigs.baseUrl + ApiEndPoints.completeProfile;
      var body = FormData.fromMap({
        "unique_code": uniqueCodeController.text,
        "name": nameController.text,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        saveObject('userData', response.data['data']);
        saveObject('token', response.data['data']['token']);
        GoRouter.of(rootNavigatorKey.currentContext!).go('/');
      }
    } catch (e) {
      if (e is DioException) {
        Map<String, dynamic> message = e.response?.data['message'];

        showErrorToast(message);
      } else {
        print(e.toString());
      }
    }
  }

  getUserData(String code) async {
    try {
      var url = ApiConfigs.baseUrl + ApiEndPoints.getUserData;
      var body = {
        "unique_code": code,
      };
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'GET', path: url, queryParameters: body),
      );
      if (response.statusCode == 200) {
        uniqueCodeError = null;
        var userData = UserData.fromJson(response.data['data']['user_data']);
        nameController.text = userData.name;
        emailController.text = userData.email;
        mobileController.text = userData.mobile;
        selectedCountryCode = countryCodes.firstWhereOrNull(
            (element) => element.id == userData.countryCodeId);
        update();
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map) {
          Map<String, dynamic> message = e.response?.data['message'];
          if (message.containsKey('unique_code')) {
            if (message['unique_code'].isNotEmpty) {
              uniqueCodeError = message['unique_code'][0] ??
                  "An unexpected error occurred. Please refresh the page or try again.";
              nameController.clear();
              emailController.clear();
              mobileController.clear();
              update();
            }
          } else {
            showErrorToast(message);
          }
        } else {
          uniqueCodeError = e.response?.data['message'] ??
              "An unexpected error occurred. Please refresh the page or try again.";
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          update();
        }
      } else {
        print(e.toString());
      }
    }
  }
}
