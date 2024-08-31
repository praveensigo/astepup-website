import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';

import '../ApiClient/ApiClient.dart';
import '../Config/ApiConfig.dart';
import '../Utils/Utils.dart';
import '../main.dart';

class LoginController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  login(BuildContext context) async {
    try {
      showLoader(context);
      var url = ApiConfigs.baseUrl + ApiEndPoints.login;
      var body = FormData.fromMap({
        "email": emailController.text,
        "password": passwordController.text,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        if (response.data['data'] is Map) {
          saveObject('userData', response.data['data']['details']);
          saveObject('token', response.data['data']['details']['token']);
          GoRouter.of(rootNavigatorKey.currentContext!).go('/');
        } else {
          Navigator.pop(context);
          showSnackBar(
            context: rootNavigatorKey.currentContext!,
            msg: "There was a problem logging you in. Please try again later.",
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      if (e is DioException) {
        print(e.response?.data);
        if (e.response?.data['message'] is Map<String, dynamic>) {
          Map<String, dynamic> message = e.response?.data['message'];
          showErrorToast(message);
        } else {
          showSnackBar(
              context: rootNavigatorKey.currentContext!,
              msg: e.response?.data['message']);
        }
      } else {
        print(e.toString());
      }
    }
  }

  logout(BuildContext context) async {
    try {
      showLoader(context);
      var url = ApiConfigs.baseUrl + ApiEndPoints.logout;
      var response = await inspector.send<dynamic>(
        RequestOptions(
          method: 'GET',
          path: url,
        ),
      );
      if (response.statusCode == 200) {
        // showToast(response.data['message'].toString());
        removename('userData');
        removename('token');
        Get.deleteAll();
        GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
      }
    } catch (e) {
      if (e is DioException) {
        Navigator.of(context).pop();
        showToast(e.response?.data['message']);
      } else {
        print(e.toString());
      }
    }
  }
}
