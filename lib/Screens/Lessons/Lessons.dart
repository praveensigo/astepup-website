import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/main.dart';

import '../../Model/SidebarMenuItemModel.dart';

class LessonScreen extends StatefulWidget {
  final Widget child;
  const LessonScreen({
    super.key,
    required this.child,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  String selectedRoute = '';
  @override
  void initState() {
    super.initState();
  }

  final sidebarController = Get.put(SideMenuManager());
  // onSelctedFUntion(String key, SideMenuItem item) {
  //   SideMenuItem? parent =
  //       sidebarController.findParentByKey(sidebarController.sideBarList, key);
  // }

  @override
  Widget build(BuildContext context) {
    selectedRoute = Get.find<LessonController>().selectedRoute.value;
    return GetBuilder<LessonController>(
      didChangeDependencies: (state) async {
        if (state.controller!.videoId.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await state.controller?.videoDetailsAPI(
                getSavedObject(StorageKeys.videoId),
                currentIndex: getSavedObject(StorageKeys.lessonIndex) ?? 1);
            sidebarController.retriveStageDetail(
                getSavedObject(StorageKeys.stageDetails).containsKey("stages")
                    ? getSavedObject(StorageKeys.stageDetails)['stages']
                    : []);
          });
        }
      },
      builder: (lessonController) {
        return LessonScaffold(
          body: widget.child,
        );
      },
    );
  }

  navigateToFunction(
      String pageRoute, BuildContext context, SideMenuItem item) {
    if (GoRouter.of(context).routeInformationProvider.value.uri.toString() !=
        pageRoute) {
      html.window.history.replaceState(
          null, "Lesson", "/detail/${getSavedObject(StorageKeys.courseId)}");
      rootNavigatorKey.currentContext!.pushReplacement(pageRoute, extra: {
        "vid": Get.find<LessonController>().videoId.toString(),
        'cid': item.idMapper?.courseId ?? getSavedObject(StorageKeys.courseId),
        'sid': item.idMapper?.stageId ?? '',
        'mid': item.idMapper?.moduleId ?? "",
      });
    }
  }
}
