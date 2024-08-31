import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'View/View.dart';

class LessonView extends StatelessWidget {
  const LessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
        return const TabletView(
          key: ValueKey('tablet'),
        );
      }
      if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
        return const MobileView(
          key: ValueKey('mobile'),
        );
      }
      return const DesktopView(
        key: ValueKey('desktop'),
      );
    });
  }
}
