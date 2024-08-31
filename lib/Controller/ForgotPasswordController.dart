import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:go_router/go_router.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

class ForgotController extends GetxController {
  DioInspector inspector = DioInspector(Dio());
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String userEmail = '';
  @override
  void onInit() {
    userEmail = getSavedObject(StorageKeys.userEmail) ?? "";
    super.onInit();
  }

  sentForgotOtp(BuildContext context, String email,
      {bool enableRedirect = true}) async {
    try {
      showLoader(context);
      userEmail = email;
      savename(StorageKeys.userEmail, email);
      var url = ApiConfigs.baseUrl + ApiEndPoints.sendOtp;
      var body = FormData.fromMap({
        "email": email,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
        }
        showSnackBar(
            context: rootNavigatorKey.currentContext!,
            msg: response.data['message']);
        if (enableRedirect) {
          if (context.mounted) {
            GoRouter.of(context).push('/otp');
          }
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: "There was a problem logging you in. Please try again later.",
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
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

  verifyOtp({required BuildContext context, required String otp}) async {
    try {
      showLoader(context);
      var url = ApiConfigs.baseUrl + ApiEndPoints.verifyOtp;
      print('user email${userEmail}');
      var body = FormData.fromMap({
        "email": userEmail,
        "otp": otp,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
          GoRouter.of(context).push('/newpassword');
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: "There was a problem logging you in. Please try again later.",
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
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

  resetPassword(BuildContext context) async {
    try {
      showLoader(context);
      var url = ApiConfigs.baseUrl + ApiEndPoints.resetPassword;
      var body = FormData.fromMap({
        "email": userEmail,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
      });
      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: body),
      );
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
          GoRouter.of(context).go('/login');
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: "There was a problem logging you in. Please try again later.",
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
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
}
