import 'dart:async';
import 'dart:html' show window, HttpRequest, PopStateEvent;
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/main.dart';

import '../Controller/LessonController.dart';
import '../Resource/Strings.dart';
import '../Model/SidebarMenuItemModel.dart';

// Create an instance of get_storage
final GetStorage storage = GetStorage();
removename(String key) {
  try {
    storage.remove(key);
  } catch (e) {
    throw Exception(e);
  }
}

saveObject(String key, value) {
  try {
    storage.write(key, json.encode(value));
  } catch (e) {
    throw Exception(e);
  }
}

savename(String key, value) {
  try {
    storage.write(key, json.encode(value));
  } catch (e) {
    throw Exception(e);
  }
}

getSavedObject(String key) {
  try {
    var data = storage.read(key);
    return data != null ? json.decode(data) : null;
  } catch (e) {
    throw Exception(e);
  }
}

clearStorage() async {
  try {
    await storage.erase();
  } catch (e) {
    throw Exception(e);
  }
}

listenKey({required String key, required Function(dynamic) callback}) {
  storage.listenKey(key, callback);
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

int limitPercentageValue(String numberString) {
  double number = double.parse(numberString);
  int intNumber = number.toInt();
  return intNumber > 100 ? 100 : intNumber;
}

showToast(String message, {BuildContext? context, SnackBarAction? action}) {
  showSnackBar(msg: message, context: rootNavigatorKey.currentContext!);
}

RichText getRequiredLabel(String fieldName) {
  return RichText(
      text: TextSpan(
          style: const TextStyle(color: Colors.black),
          text: fieldName,
          children: const [
        TextSpan(text: ' *', style: TextStyle(color: Colors.red))
      ]));
}

showErrorToast(Map<String, dynamic> message) {
  if (message.containsKey('mobile')) {
    if (message['mobile'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['mobile'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('password')) {
    if (message['password'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['password'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('password_confirmation')) {
    if (message['password_confirmation'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['password_confirmation'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('email')) {
    if (message['email'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['email'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('unique_code')) {
    if (message['unique_code'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['unique_code'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('course_id')) {
    if (message['course_id'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['course_id'][0] ?? "Something went wrong");
    }
  }
  if (message.containsKey('country_code')) {
    if (message['country_code'].isNotEmpty) {
      showSnackBar(
          context: rootNavigatorKey.currentContext!,
          msg: message['country_code'][0] ?? "Something went wrong");
    }
  }
}

void clearBackNavigationStack(
    {String title = '',
    required String currentPath,
    required context,
    required String nextPath,
    dynamic extra}) {
  window.history.replaceState(null, title, currentPath);
  window.onPopState.listen((PopStateEvent event) {
    window.location.href = currentPath;
  });
  GoRouter.of(context).go(nextPath, extra: extra);
}

showLoader(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
            child: Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(10),
          child: const CircularProgressIndicator(),
        ));
      });
}

String getroute(BuildContext context) {
  final currentLocation =
      GoRouter.of(context).routeInformationProvider.value.uri;
  List<String> segments = currentLocation.pathSegments;
  if (segments.length >= 2) {
    return '/${segments[0]}/${segments[1]}';
  } else {
    return '';
  }
}

String getDomainFromUrl(String url) {
  if (url.isEmpty) {
    return '';
  }
  RegExp regExp =
      RegExp(r'^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n?]+)');
  RegExpMatch? match = regExp.firstMatch(url);
  String? domain = match!.group(1);
  return domain ?? url;
}

String generateKeyForNode(String inputString) {
  List<int> bytes = utf8.encode(inputString);
  String hexString = hex.encode(bytes);
  int number = int.parse(hexString, radix: 16);
  String key = Key(number.toString()).toString();
  return key;
}

double calculateLineWidth(String text, {double fontSize = 16.0}) {
  const double kMinSnackBarPadding = 18.0;
  final textPainter = TextPainter(
    maxLines: 1,
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: text,
      style: Theme.of(rootNavigatorKey.currentContext!)
          .textTheme
          .bodyMedium!
          .copyWith(),
    ),
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.width + kMinSnackBarPadding * 2;
}

void showSnackBar({required String msg, required BuildContext context}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      behavior: SnackBarBehavior.floating,
      width: calculateLineWidth(msg),
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

class Debouncer {
  final Duration duration;
  late Timer _timer;

  Debouncer({required this.duration}) {
    _timer = Timer(Duration.zero, () {}); // Initialize with a dummy timer
  }

  void run(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }
}

int convertStringToInteger(String value) {
  try {
    double doubleValue = double.parse(value);
    return doubleValue.toInt();
  } catch (e) {
    // Handle invalid input, e.g., return 0
    return 0;
  }
}

navigateToFunction(String pageRoute, BuildContext context, SideMenuItem item) {
  if (GoRouter.of(context).routeInformationProvider.value.uri.toString() !=
      pageRoute) {
    window.history.replaceState(
        null, "Lesson", "/detail/${getSavedObject(StorageKeys.courseId)}");
    rootNavigatorKey.currentContext!.pushReplacement(pageRoute, extra: {
      "vid": Get.find<LessonController>().videoId.toString(),
      'cid': item.idMapper?.courseId ?? getSavedObject(StorageKeys.courseId),
      'sid': item.idMapper?.stageId ?? '',
      'mid': item.idMapper?.moduleId ?? "",
    });
  }
}

String getValueOrNull(Map<String, dynamic> map, String key) {
  if (map.containsKey(key)) {
    return map[key];
  } else {
    return "0.0";
  }
}
