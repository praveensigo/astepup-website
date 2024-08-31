import 'package:flutter/material.dart';

import '../../Resource/colors.dart';

class PercentageWidgetBuilder extends StatelessWidget {
  final int userPercentage;
  final int checkPercentage;
  final Widget child;

  const PercentageWidgetBuilder(
      {super.key,
      required this.userPercentage,
      required this.checkPercentage,
      required this.child});

  @override
  Widget build(BuildContext context) {
    if (checkPercentage == 0) {
      return child;
    } else if (userPercentage >= checkPercentage) {
      return child;
    } else {
      return const SizedBox.shrink();
    }
  }
}

String getResultText(
    {required int userPercentage, required int checkPercentage}) {
  if (checkPercentage == 0) {
    return "Passed";
  } else if (userPercentage >= checkPercentage) {
    return "Passed";
  } else {
    return "Failed";
  }
}

Color getResultColor(
    {required int userPercentage, required int checkPercentage}) {
  if (checkPercentage == 0) {
    return green;
  } else if (userPercentage >= checkPercentage) {
    return green;
  } else {
    return red;
  }
}

bool getResultBool(
    {required int userPercentage, required int checkPercentage}) {
  if (checkPercentage == 0) {
    return true;
  } else if (userPercentage >= checkPercentage) {
    return true;
  } else {
    return false;
  }
}
