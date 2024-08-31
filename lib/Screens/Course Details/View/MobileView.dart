import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../Widgets/Widgets.dart';
import '../Widgets/Widgets.dart';

class MobileView extends StatefulWidget {
  final String courseId;
  const MobileView({super.key, required this.courseId});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return GetBuilder<CourseDetailsController>(
        initState: (_) {},
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 50),
                      color: colorPrimary.withOpacity(.5),
                      child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.courseDetails!.courseName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 15),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Text(
                                            controller.courseDetails!
                                                .courseDescription,
                                            maxLines: 8,
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (Get.find<CourseDetailsController>()
                                              .courseDetails!
                                              .courseStatus ==
                                          3)
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 140, maxHeight: 40),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                if (controller.courseDetails!
                                                        .evaluationStatus ==
                                                    '2') {
                                                  context.go('/viewCertificate',
                                                      extra: {
                                                        "courseId":
                                                            widget.courseId,
                                                        "courseName": controller
                                                            .courseDetails
                                                            ?.courseName,
                                                      });
                                                } else {
                                                  GoRouter.of(context)
                                                      .go('/evaluation-survey');
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  side: const BorderSide(
                                                      color: textColor,
                                                      width: 1)),
                                              child: Text(
                                                "VIEW CERTIFICATE",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 7),
                                Expanded(
                                  flex: 1,
                                  child: CachedNetworkImage(
                                    httpHeaders: const {
                                      'Access-Control-Allow-Origin': '*',
                                      'Access-Control-Allow-Method': 'GET',
                                    },
                                    imageUrl: ApiConfigs.imageUrl +
                                        controller.courseDetails!.image,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 250,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider)),
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                          width: 250,
                                          height: 150,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            width: 250,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        AssetManager
                                                            .errorImage)))),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Positioned.fill(
                      bottom: -20,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: colorPrimary,
                                border: Border.all(
                                    color: Colors.grey[500]!, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              CourseStatusWidget(
                                icon: CustomIcons.hour,
                                title: controller.courseDetails!.durationHours,
                                isMobile: sizeInfo.isMobile,
                              ),
                              const SizedBox(width: 7),
                              CourseStatusWidget(
                                icon: CustomIcons.book,
                                title:
                                    "${controller.courseDetails!.stageCount} Stages",
                                isMobile: sizeInfo.isMobile,
                              ),
                              const SizedBox(width: 7),
                              CourseStatusWidget(
                                title:
                                    "${controller.courseDetails!.sectionCount} Sections",
                                icon: CustomIcons.section,
                                isMobile: sizeInfo.isMobile,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    ProgressTile(
                      width: double.infinity,
                      title:
                          "${controller.courseDetails!.lessonCompletedPercentage}${courseProgressList[0]['title']}",
                      icon: courseProgressList[0]['icon'],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    ProgressTile(
                      width: double.infinity,
                      title:
                          "${controller.courseDetails!.quizCompletedPercentage}${courseProgressList[1]['title']}",
                      icon: courseProgressList[1]['icon'],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    ProgressTile(
                      width: double.infinity,
                      title:
                          "${controller.courseDetails!.quizCorrectPercentage}${courseProgressList[2]['title']}",
                      icon: courseProgressList[2]['icon'],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    ProgressTile(
                      width: double.infinity,
                      title:
                          "${controller.courseDetails!.totalHourSpent}${courseProgressList[3]['title']}",
                      icon: courseProgressList[3]['icon'],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stages",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          controller: controller.autoScrollController,
                          itemCount: controller.courseDetails!.stages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemBuilder: (_, i) {
                            return AutoScrollTag(
                              key: ValueKey(i),
                              controller: controller.autoScrollController,
                              index: i,
                              child: StageWidget(
                                isLocked: i > 0,
                                key: ValueKey(i),
                                isSelected: controller.stageid ==
                                    controller.courseDetails!.stages[i].id,
                                index: i,
                                stage: controller.courseDetails!.stages[i],
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
          );
        },
      );
    });
  }
}
