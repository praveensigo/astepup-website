import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';

import 'Widgets.dart';

class CourseTitleWidget extends StatefulWidget {
  final String courseName;
  final String courseDesec;
  final String courseImage;
  final String courseHour;
  final String stageCount;
  final String sectionCount;
  final String courseId;
  const CourseTitleWidget({
    Key? key,
    required this.courseName,
    required this.courseDesec,
    required this.courseImage,
    required this.courseHour,
    required this.stageCount,
    required this.sectionCount,
    required this.courseId,
  }) : super(key: key);

  @override
  State<CourseTitleWidget> createState() => _CourseTitleWidgetState();
}

class _CourseTitleWidgetState extends State<CourseTitleWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height:
                sizingInformation.deviceScreenType == DeviceScreenType.tablet
                    ? size.height / 4
                    : size.height / 2,
            constraints: const BoxConstraints(minHeight: 300),
            color: colorPrimary.withOpacity(.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                height: (sizingInformation.deviceScreenType ==
                            DeviceScreenType.tablet
                        ? size.height * .25
                        : (size.height / 2.2)) -
                    50,
                constraints: const BoxConstraints(minHeight: 230),
                width: size.width - (size.width * .13),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: sizingInformation.deviceScreenType ==
                        DeviceScreenType.mobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.courseName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                flex: 1,
                                child: CachedNetworkImage(
                                  httpHeaders: const {
                                    'Access-Control-Allow-Origin': '*',
                                    'Access-Control-Allow-Methods': 'GET, POST',
                                    'Access-Control-Allow-Headers': '*',
                                  },
                                  imageUrl: widget.courseImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                AssetManager.errorImage))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Expanded(
                              child: AutoSizeText(
                                widget.courseDesec,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.courseName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: SingleChildScrollView(
                                          scrollDirection:
                                              Axis.vertical, //.horizontal
                                          child: Text(
                                            widget.courseDesec,
                                            textAlign: TextAlign.justify,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      )),
                                  // if (Get.find<CourseDetailsController>()
                                  //         .courseDetails!
                                  //         .courseStatus ==
                                  //     3)
                                  //   const Spacer(),
                                  if (Get.find<CourseDetailsController>()
                                          .courseDetails!
                                          .courseStatus ==
                                      3)
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: 150,
                                            maxWidth: 250,
                                            maxHeight: 50),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              savename("courseName",
                                                  widget.courseName);
                                              if (Get.find<
                                                          CourseDetailsController>()
                                                      .courseDetails!
                                                      .evaluationStatus ==
                                                  '2') {
                                                context.go(
                                                    '/viewCertificate/${widget.courseId.toString()}',
                                                    extra: {
                                                      "courseName":
                                                          widget.courseName
                                                    });
                                              } else {
                                                GoRouter.of(context)
                                                    .go('/evaluation-survey');
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: textColor,
                                                    width: 1)),
                                            child: Text(
                                              "VIEW CERTIFICATE",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: CachedNetworkImage(
                              httpHeaders: const {
                                'Access-Control-Allow-Origin': '*',
                                'Access-Control-Allow-Methods': 'GET, POST',
                                'Access-Control-Allow-Headers': '*',
                              },
                              imageUrl: widget.courseImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: imageProvider)),
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            AssetManager.errorImage))),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: -20,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: colorPrimary,
                        border: Border.all(color: Colors.grey[500]!, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CourseStatusWidget(
                              icon: CustomIcons.hour,
                              isMobile: sizingInformation.isMobile,
                              title: widget.courseHour),
                          SizedBox(width: sizingInformation.isMobile ? 5 : 25),
                          CourseStatusWidget(
                              icon: CustomIcons.book,
                              isMobile: sizingInformation.isMobile,
                              title: "${widget.stageCount} Stages"),
                          SizedBox(width: sizingInformation.isMobile ? 5 : 25),
                          CourseStatusWidget(
                            title: "${widget.sectionCount} Sections",
                            icon: CustomIcons.section,
                            isMobile: sizingInformation.isMobile,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
