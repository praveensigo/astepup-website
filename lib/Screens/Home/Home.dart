import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/AppMonitorController.dart';
import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Utils/Helper.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:astepup_website/Controller/HomeController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Screens.dart';

List<Map<String, dynamic>> progressInfoList = [
  {
    "title": "0% Lessons completed",
    "icon": "Assets/Svg/lesson.svg",
    'desc': "The percentage of lessons completed for the entire course."
  },
  {
    "title": "0% Questions completed",
    "icon": "Assets/Svg/questions.svg",
    'desc': "The percentage of question completed for the entire course."
  },
  {
    "title": "0% Questions correct",
    "icon": "Assets/Svg/correct answer.svg",
    'desc':
        "Percentage of correct questions out of submitted questions for the entire course."
  },
  {
    "title": "total spent",
    "icon": "Assets/Svg/hours.svg",
    'desc': "The total hours spent in this platform."
  }
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AutoScrollController controller;
  final home = Get.put(HomeController());
  @override
  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    super.initState();
  }

  void progressInfo({
    required String lessonComplete,
    required String quizComplete,
    required String quizCorrect,
    required String totalHour,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (buildContext) {
        var size = MediaQuery.of(context).size;
        return Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ColoredContainer(
            constraints: BoxConstraints(
                minWidth: 300,
                maxHeight: size.width < 540 ? 430 : 390,
                maxWidth: 560),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProgressTile(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                width: double.infinity,
                                mainAxisAlignment: MainAxisAlignment.start,
                                decoration: const BoxDecoration(),
                                title: progressList[0]['title'] ?? "Title",
                                icon: progressList[0]['icon'] ?? "",
                              ),
                              Text(progressList[0]["desc"] ?? "Desc",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProgressTile(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                width: double.infinity,
                                mainAxisAlignment: MainAxisAlignment.start,
                                decoration: const BoxDecoration(),
                                title: progressList[1]['title'] ?? "",
                                icon: progressList[1]['icon'] ?? "",
                              ),
                              Text(progressList[1]["desc"] ?? "Desc",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProgressTile(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                width: double.infinity,
                                mainAxisAlignment: MainAxisAlignment.start,
                                decoration: const BoxDecoration(),
                                title: progressList[2]['title'] ?? "",
                                icon: progressList[2]['icon'] ?? "",
                              ),
                              Text(progressList[2]["desc"] ?? "Desc",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProgressTile(
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                width: double.infinity,
                                mainAxisAlignment: MainAxisAlignment.start,
                                decoration: const BoxDecoration(),
                                title: progressList[3]['title'] ?? "",
                                icon: progressList[3]['icon'] ?? "",
                              ),
                              Text(progressList[3]["desc"] ?? "Desc",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                      ]),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 30,
                      )),
                )
              ],
            ),
          ),
        ));
      },
    );
  }

  int currentIndex = 0;
  Future<void> scrollListView(int index) async {
    await controller.scrollToIndex(currentIndex,
        preferPosition: AutoScrollPosition.begin);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (size.width < 890) {
      currentIndex = 2;
    }
    if (size.width < 640) {
      currentIndex = 1;
    }
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
          appBar: CustomAppBar(
            height: sizeInfo.isMobile ? 80 : 120,
          ),
          body: GetBuilder<HomeController>(didChangeDependencies: (state) {
            state.controller?.getHome();
          }, builder: (homecontroller) {
            return homecontroller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizeInfo.isMobile ? 20 : 50,
                          vertical: sizeInfo.isMobile ? 25 : 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, ${homecontroller.username}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 50,
                                child: ListView(
                                    controller: controller,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      AutoScrollTag(
                                        key: const ValueKey(0),
                                        controller: controller,
                                        index: 0,
                                        child: ProgressTile(
                                          width: size.width / 5,
                                          title: homecontroller
                                                  .lessonCompletedPercentage +
                                              courseProgressList[0]['title'],
                                          icon: courseProgressList[0]['icon'],
                                        ),
                                      ),
                                      AutoScrollTag(
                                        key: const ValueKey(1),
                                        controller: controller,
                                        index: 1,
                                        child: ProgressTile(
                                          width: size.width / 5,
                                          title: homecontroller
                                                  .quizCompletedPercentage +
                                              courseProgressList[1]['title'],
                                          icon: courseProgressList[1]['icon'],
                                        ),
                                      ),
                                      AutoScrollTag(
                                        key: const ValueKey(2),
                                        controller: controller,
                                        index: 2,
                                        child: ProgressTile(
                                          width: size.width / 5,
                                          title: homecontroller
                                                  .quizCorrectPercentage +
                                              courseProgressList[2]['title'],
                                          icon: courseProgressList[2]['icon'],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AutoScrollTag(
                                            key: const ValueKey(3),
                                            controller: controller,
                                            index: 3,
                                            child: ProgressTile(
                                              width: size.width / 5,
                                              title: homecontroller
                                                      .hoursTotalSpent +
                                                  courseProgressList[3]
                                                      ['title'],
                                              icon: courseProgressList[3]
                                                  ['icon'],
                                            ),
                                          ),
                                          // GetBuilder<AppMonitorController>(
                                          //   initState: (_) {},
                                          //   init: AppMonitorController(),
                                          //   builder: (timerController) {
                                          //     Duration totalhout = timerController
                                          //                 .getTotalTime() ==
                                          //             0
                                          //         ? Duration.zero
                                          //         : Duration(
                                          //             seconds: timerController
                                          //                 .getTotalTime());
                                          //     return AutoScrollTag(
                                          //       key: ValueKey(3),
                                          //       controller: controller,
                                          //       index: 3,
                                          //       child: ProgressTile(
                                          //         width: size.width / 5,
                                          //         title:
                                          //             "${prettyDuration(totalhout)}${progressInfoList[3]['title']}",
                                          //         icon: progressInfoList[3]
                                          //             ['icon'],
                                          //       ),
                                          //     );
                                          //   },
                                          // ),
                                          const SizedBox(width: 5),
                                          IconButton(
                                            onPressed: () => progressInfo(
                                                totalHour: homecontroller
                                                    .hoursTotalSpent,
                                                lessonComplete: homecontroller
                                                    .lessonCompletedPercentage,
                                                quizComplete: homecontroller
                                                    .quizCompletedPercentage,
                                                quizCorrect: homecontroller
                                                    .quizCorrectPercentage),
                                            icon: const Icon(
                                              Icons.info_outline,
                                              size: 24,
                                              color: textColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                              size.width < 890
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (currentIndex > 0) {
                                                  currentIndex -= 1;
                                                }
                                                scrollListView(currentIndex);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .arrow_circle_left_outlined,
                                                size: 30,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                if (currentIndex < 3) {
                                                  currentIndex += 1;
                                                } else {
                                                  currentIndex = 0;
                                                }
                                                scrollListView(currentIndex);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                size: 30,
                                              )),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              homecontroller.inprogresscourse.isEmpty &&
                                      homecontroller.courselist.isEmpty
                                  ? const HomeEmptyState()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 25),
                                        homecontroller
                                                .inprogresscourse.isNotEmpty
                                            ? CourseListingWidget(
                                                title: 'In Progress Courses',
                                                physics: size.width < 550
                                                    ? const NeverScrollableScrollPhysics()
                                                    : const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    size.width < 550
                                                        ? Axis.vertical
                                                        : Axis.horizontal,
                                                length: homecontroller
                                                    .inprogresscourse.length,
                                                course: homecontroller
                                                    .inprogresscourse,
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(height: 25),
                                        homecontroller.courselist.isNotEmpty
                                            ? CourseListingWidget(
                                                title: 'My Courses',
                                                physics: size.width < 550
                                                    ? const NeverScrollableScrollPhysics()
                                                    : const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    size.width < 550
                                                        ? Axis.vertical
                                                        : Axis.horizontal,
                                                length: homecontroller
                                                    .courselist.length,
                                                course:
                                                    homecontroller.courselist,
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
          }));
    });
  }
}

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220, maxHeight: 350),
            child: Image.asset(AssetManager.nocourse, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            Strings.nocourse,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(Strings.nocourseavailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
