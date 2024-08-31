import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Screens/Widgets/ProgreesTile.dart';

import '../Widgets/appbar.dart';
import 'View/MobileView.dart';
import 'Widgets/Widgets.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final courseController = Get.put(CourseDetailsController());

  @override
  void dispose() {
    var courseController = Get.find<CourseDetailsController>();
    courseController.currentLoadingStatus = LoadingStatus.courseLoading;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCourseDetails();
  }

  getCourseDetails() async {
    courseController.courseId = widget.courseId;
    savename(StorageKeys.courseId, widget.courseId);
    await courseController.courseDetailsAPI(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseDetailsController>(
      initState: (_) {},
      didChangeDependencies: (state) async {},
      dispose: (_) {},
      builder: (controller) {
        return ResponsiveBuilder(builder: (context, sizingInformation) {
          return Scaffold(
              appBar: CustomAppBar(
                height: sizingInformation.isMobile ? 80 : 120,
              ),
              body: controller.currentLoadingStatus ==
                      LoadingStatus.courseLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.currentLoadingStatus == LoadingStatus.error
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AssetManager.nocourse),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Oops! It seems like we've run into a hiccup on our website, but don't worry, we're on it",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50)),
                                  onPressed: () {
                                    GoRouter.of(context).go('/');
                                  },
                                  child: Text(
                                    "Go Home",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        )
                      : sizingInformation.isMobile
                          ? MobileView(
                              courseId: widget.courseId,
                            )
                          : SingleChildScrollView(
                              controller: controller.scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CourseTitleWidget(
                                    courseId: widget.courseId,
                                    courseImage: ApiConfigs.imageUrl +
                                        controller.courseDetails!.image,
                                    courseDesec: controller
                                        .courseDetails!.courseDescription,
                                    courseName:
                                        controller.courseDetails!.courseName,
                                    courseHour:
                                        controller.courseDetails!.durationHours,
                                    stageCount: controller
                                        .courseDetails!.stageCount
                                        .toString(),
                                    sectionCount: controller
                                        .courseDetails!.sectionCount
                                        .toString(),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 70,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(children: [
                                              ProgressTile(
                                                width: sizingInformation
                                                        .screenSize.width /
                                                    4.5,
                                                title:
                                                    "${controller.courseDetails!.lessonCompletedPercentage}${courseProgressList[0]['title']}",
                                                icon: courseProgressList[0]
                                                    ['icon'],
                                                margin:
                                                    !sizingInformation.isDesktop
                                                        ? const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5)
                                                        : null,
                                                titleStyle: !sizingInformation
                                                        .isDesktop
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                              ),
                                              ProgressTile(
                                                width: sizingInformation
                                                        .screenSize.width /
                                                    4.5,
                                                title:
                                                    "${controller.courseDetails!.quizCompletedPercentage}${courseProgressList[1]['title']}",
                                                icon: courseProgressList[1]
                                                    ['icon'],
                                                margin:
                                                    !sizingInformation.isDesktop
                                                        ? const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5)
                                                        : null,
                                                titleStyle: !sizingInformation
                                                        .isDesktop
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                              ),
                                              ProgressTile(
                                                width: sizingInformation
                                                        .screenSize.width /
                                                    4.5,
                                                title:
                                                    "${controller.courseDetails!.quizCorrectPercentage}${courseProgressList[2]['title']}",
                                                icon: courseProgressList[2]
                                                    ['icon'],
                                                margin:
                                                    !sizingInformation.isDesktop
                                                        ? const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5)
                                                        : null,
                                                titleStyle: !sizingInformation
                                                        .isDesktop
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                              ),
                                              ProgressTile(
                                                width: sizingInformation
                                                        .screenSize.width /
                                                    4.5,
                                                title:
                                                    "${controller.courseDetails!.totalHourSpent}${courseProgressList[3]['title']}",
                                                icon: courseProgressList[3]
                                                    ['icon'],
                                                margin:
                                                    !sizingInformation.isDesktop
                                                        ? const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5)
                                                        : null,
                                                titleStyle: !sizingInformation
                                                        .isDesktop
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                              )
                                            ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text("Stages :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ListView.separated(
                                            shrinkWrap: true,
                                            controller:
                                                controller.autoScrollController,
                                            itemCount: controller
                                                .courseDetails!.stages.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 15),
                                            itemBuilder: (_, i) {
                                              return AutoScrollTag(
                                                key: ValueKey(i),
                                                controller: controller
                                                    .autoScrollController,
                                                index: i,
                                                child: StageWidget(
                                                  isLocked: false,
                                                  key: ValueKey(i),
                                                  isSelected:
                                                      controller.stageid ==
                                                          controller
                                                              .courseDetails!
                                                              .stages[i]
                                                              .id,
                                                  index: i,
                                                  stage: controller
                                                      .courseDetails!.stages[i],
                                                ),
                                              );
                                            }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
        });
      },
    );
  }
}
