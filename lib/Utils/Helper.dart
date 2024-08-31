import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final hour = timeOfDay.hour.toString().padLeft(2, '0');
  final minute = timeOfDay.minute.toString().padLeft(2, '0');
  const second = '00';
  return '$hour:$minute:$second';
}

String formatDuration(Duration duration) {
  final hour = duration.inHours.toString().padLeft(2, '0');
  final minute = duration.inMinutes.toString().padLeft(2, '0');
  const second = '00';
  return '$hour:$minute:$second';
}

TimeOfDay stringToTimeOfDay(String timeString) {
  List<String> parts = timeString.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  return TimeOfDay(hour: hours, minute: minutes);
}

Duration stringToDuration(String durationString) {
  List<String> parts = durationString.split(':');
  int hours = parts.isNotEmpty ? int.parse(parts[0]) : 0;
  int minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
  int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

Duration convertStringToDuration(String timeString) {
  List<String> parts = timeString.split(' ');
  int hours = 0;
  int minutes = 0;

  for (String part in parts) {
    if (part.contains('hour')) {
      hours = int.tryParse(part.split(' ')[0]) ?? 0;
    } else if (part.contains('minute')) {
      minutes = int.tryParse(part.split(' ')[0]) ?? 0;
    }
  }

  return Duration(hours: hours, minutes: minutes);
}

String calculateTotalTime(List<Duration> durations) {
  Duration totalDuration = const Duration();
  for (var duration in durations) {
    totalDuration += duration;
  }
  String hours = totalDuration.inHours.toString().padLeft(2, '0');
  String minutes =
      (totalDuration.inMinutes.remainder(60)).toString().padLeft(2, '0');
  String seconds =
      (totalDuration.inSeconds.remainder(60)).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

String prettyDuration(Duration duration) {
  if (duration == Duration.zero) {
    return '0 Hour ';
  }
  var components = <String>[];
  var days = duration.inDays;
  if (days != 0) {
    components.add('$days Days ');
  }
  var hours = duration.inHours % 24;
  if (hours != 0) {
    components.add('$hours Hour ');
  }
  var minutes = duration.inMinutes % 60;
  if (minutes != 0) {
    components.add('$minutes Minutes ');
  }

  var seconds = duration.inSeconds % 60;
  var centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
  if (components.isEmpty || seconds != 0 || centiseconds != 0) {
    components.add('0 Hour ');
    if (centiseconds != 0) {
      components.add('.');
      components.add(centiseconds.toString().padLeft(0, '0'));
    }
  }
  return components.first;
}

Duration parseDurationFromString(String durationString) {
  List<String> parts = durationString.split(":");
  int hours = 0, minutes = 0, seconds = 0, microseconds = 0;
  if (parts.length >= 3) {
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    List<String> secondsParts = parts[2].split(".");
    seconds = int.parse(secondsParts[0]);
    if (secondsParts.length > 1) {
      String microsecondsStr = secondsParts[1].padRight(6, '0');
      microseconds = int.parse(microsecondsStr.substring(0, 6));
    }
  } else if (parts.length == 2) {
    minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split(".");
    seconds = int.parse(secondsParts[0]);
    if (secondsParts.length > 1) {
      String microsecondsStr = secondsParts[1].padRight(6, '0');
      microseconds = int.parse(microsecondsStr.substring(0, 6));
    }
  } else {
    throw ArgumentError("Invalid duration string: $durationString");
  }

  return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      microseconds: microseconds);
}

bool areDatesEqual(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

extension Target on Object {
  bool isAndroid() {
    return Platform.isAndroid;
  }

  bool isIOS() {
    return Platform.isIOS;
  }

  bool isLinux() {
    return Platform.isLinux;
  }

  bool isWindows() {
    return Platform.isWindows;
  }

  bool isMacOS() {
    return Platform.isMacOS;
  }

  bool isWeb() {
    return kIsWeb;
  }
}

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }
}

bool compareHour(DateTime startTime, DateTime endTime) {
  if (startTime.isAfter(endTime)) {
    Duration difference = endTime.difference(startTime);
    int hoursLeft = difference.inHours;
    return hoursLeft < 12;
  }
  return false;
}

bool isVimeoVideo(String url) {
  var regExp = RegExp(
    r"^((https?)://)?(www.)?vimeo\.com/(\d+).*$",
    caseSensitive: false,
    multiLine: false,
  );
  final match = regExp.firstMatch(url);
  if (match != null && match.groupCount >= 1) return true;
  return false;
}

bool isYouTubeVideo(String url) {
  var regExp = RegExp(
    r"^((https?)://)?(www\.)?(youtube\.com|youtu\.?be)/.+",
    caseSensitive: false,
    multiLine: false,
  );
  final match = regExp.firstMatch(url);
  return match != null;
}
