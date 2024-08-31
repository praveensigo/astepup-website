import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Repository/MaintenanceRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';

import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DioInspector {
  final Dio _dio;
  DioInspector(this._dio) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (error.response!.statusCode == 401) {
            clearStorage();
            showToast(Strings.unauthenticated);
            GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }
  Future<Response<T>> send<T>(RequestOptions options,
      {ResponseType? responseType}) async {
    try {
      var token = getSavedObject("token") ?? "";
      Future<void> maintenanceData = MaintenanceRepository.getMaintenanceData();
      Future<Response<T>> response = _dio.request<T>(options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            responseType: responseType,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST',
              'Access-Control-Allow-Headers': '*',
              'Authorization': 'Bearer $token'
            },
          ));
      await Future.wait([
        response,
        maintenanceData,
      ]);
      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          await clearStorage();
          GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
        }
        if (e.response?.statusCode == 404) {
          GoRouter.of(rootNavigatorKey.currentContext!).pushReplacement('/404',
              extra: {'api': options.path, 'method': options.method});
        }
        // if (e.response?.statusCode == 500) {
        //   GoRouter.of(rootNavigatorKey.currentContext!).pushReplacement('/500');
        // }
      }
      return Future.error(e);
    }
  }
}
