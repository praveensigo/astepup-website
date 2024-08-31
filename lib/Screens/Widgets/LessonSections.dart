import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'package:astepup_website/Screens/Lessons/Widgets/Sidebar/flutter_sidebar.dart';
import 'package:astepup_website/Utils/Utils.dart';

class LessonSectionLayout extends StatelessWidget {
  final Widget body;
  const LessonSectionLayout({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 950
          ? AppBar(
              elevation: 0,
              backgroundColor: scaffoldBG,
              leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    var videoId = getSavedObject(StorageKeys.videoId) ?? "";
                    var videoIndex =
                        getSavedObject(StorageKeys.lessonIndex) ?? 1;
                    if (videoId.isNotEmpty) {
                      await Get.find<LessonController>()
                          .changeVideo(videoId, videoIndex);
                      html.window.history.replaceState(null, "details",
                          "/detail/${getSavedObject(StorageKeys.courseId)}");
                      GoRouter.of(context).go('/lesson', extra: {
                        "vid": videoId,
                      });
                    } else {
                      html.window.history.replaceState(null, "details",
                          "/detail/${getSavedObject(StorageKeys.courseId)}");
                      GoRouter.of(context).go(
                        "/detail/${getSavedObject(StorageKeys.courseId)}",
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )
          : null,
      endDrawer: MediaQuery.of(context).size.width < 950
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: LesssonSideBar(
                  width: double.infinity,
                  controller: Get.find<SideMenuManager>().sideBarController,
                ),
              ),
            )
          : null,
      body: body,
    );
  }
}
