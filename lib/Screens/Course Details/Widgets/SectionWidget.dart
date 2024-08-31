import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Model/CourseQuizModel.dart';
import 'package:astepup_website/Repository/QuizRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/SectionDetailModel.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/CourseDetail.dart';
import 'package:astepup_website/Screens/Screens.dart';

class SectionWidget extends StatefulWidget {
  SectionWidget({
    super.key,
    required this.index,
    required this.section,
    required this.isExpanded,
    required this.isLocked,
    required this.totalLength,
    this.moduleDetails,
    this.stageDetails,
    this.moduleEnd = false,
    this.stageEnd = false,
    this.onSectionCompleteCallback,
  });

  final int index;
  final int totalLength;
  bool isExpanded;
  final bool isLocked;
  final ModuleQuiz? moduleDetails;
  final VoidCallback? onSectionCompleteCallback;
  final Section section;
  final bool moduleEnd;
  final bool stageEnd;
  final StageQuiz? stageDetails;

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  var currentLoadingStatus = LoadingStatus.section;
  bool expanded = false;
  ExpansionTileController expandsionController = ExpansionTileController();
  final quizRepository = QuizRepository();
  SectionDetail? sectionDetail;
  @override
  void initState() {
    super.initState();
  }

  void getUpdate(CourseDetailsController controller) async {
    if (widget.moduleEnd &&
        widget.moduleDetails!.quizCount == 0 &&
        widget.index == widget.totalLength - 1) {
      controller.courseRepository.updateUserModuleStatus(
          widget.stageDetails!.id.toString(),
          widget.moduleDetails!.id.toString());
    }
    if (widget.stageEnd &&
        widget.stageDetails!.quizCount == 0 &&
        widget.index == widget.totalLength - 1) {
      controller.courseRepository
          .updateUserStageStatus(widget.stageDetails!.id.toString());
    }
    if (sectionDetail!.videos.length == 1 &&
        sectionDetail!.questionCount == 0) {
      controller.courseRepository.updateUserSectionStatus(
          stageId: widget.stageDetails!.id.toString(),
          moduleId: widget.moduleDetails!.id.toString(),
          sectionId: sectionDetail!.sectionId.toString());
    }
  }

  TextStyle? getTextStyle(bool isMobile) {
    if (isMobile) {
      return Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.w700);
    } else {
      return Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w700);
    }
  }

  Future<void> navigateLessonScreen(
      {required Video video, required int currentIndex}) async {
    var controller = Get.find<CourseDetailsController>();
    controller.courseRepository.changeExpandedStatus(
        stageId: widget.stageDetails!.id.toString(),
        moduleId: widget.moduleDetails!.id.toString(),
        sectionId: sectionDetail!.sectionId.toString());
    savename(StorageKeys.videoId, video.videoId.toString());
    savename(StorageKeys.lessonIndex, currentIndex + 1);
    if ((sectionDetail!.videoStatus
                .firstWhereOrNull((element) => element.videoId == video.videoId)
                ?.watchStatus ??
            2) !=
        1) {
      await controller.courseRepository.updateVideoStatus(
          stageId: widget.stageDetails!.id.toString(),
          cousreId: controller.courseId ?? getSavedObject(StorageKeys.courseId),
          moduleId: widget.moduleDetails!.id.toString(),
          sectionId: sectionDetail!.sectionId.toString(),
          videoId: video.videoId.toString());
    }
    getUpdate(controller);
    if (mounted) {
      var selectedKey = controller.courseRepository.findElementKey(
        stageId: widget.stageDetails!.id,
        moduleId: widget.moduleDetails!.id,
        sectionId: sectionDetail!.sectionId,
        videoId: video.videoId,
        type: MenuType.video,
      );
      context.go(
        '/lesson',
        extra: {
          'vid': "${video.videoId}",
          "selectedStageId": "${widget.stageDetails!.id}",
          'selectedKey': selectedKey
        },
      );
    }
  }

  void quizTilePress() {
    var controller = Get.find<CourseDetailsController>();
    var videoStatus =
        sectionDetail!.videoStatus.firstWhereOrNull((e) => e.watchStatus == 2);
    if (videoStatus == null) {
      controller.courseRepository.changeExpandedStatus(
          stageId: widget.stageDetails!.id.toString(),
          moduleId: widget.moduleDetails!.id.toString(),
          sectionId: sectionDetail!.sectionId.toString());
      var selectedKey = controller.courseRepository.findElementKey(
        stageId: widget.stageDetails!.id,
        moduleId: widget.moduleDetails!.id,
        sectionId: sectionDetail!.sectionId,
        type: MenuType.sectionQuiz,
      );
      context.go('/lesson/section/${sectionDetail!.sectionId}', extra: {
        'mid': widget.moduleDetails!.id.toString(),
        "sid": widget.stageDetails!.id.toString(),
        "selectedStageId": "${widget.stageDetails!.id}",
        'selectedKey': selectedKey
      });
    } else {
      showToast(Strings.lessonError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return GetBuilder<CourseDetailsController>(
            initState: (_) {},
            didChangeDependencies: (state) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                sectionDetail = await state.controller?.sectionDetailsAPI(
                    state.controller?.sectionId == null
                        ? widget.section.sectionId.toString()
                        : state.controller!.sectionId.toString(),
                    stageId: state.controller?.stageid == null
                        ? widget.stageDetails!.id.toString()
                        : state.controller!.stageid.toString(),
                    moduleId: state.controller?.moduleid == null
                        ? widget.moduleDetails!.id.toString()
                        : state.controller!.moduleid.toString());
                state.controller?.sectionId = null;
                if (sectionDetail == null) {
                  expandsionController.collapse();
                  widget.isExpanded = false;
                  if (widget.isExpanded) {
                    expandsionController.collapse();
                    showToast(Strings.sectionError);
                  }
                  currentLoadingStatus = LoadingStatus.error;
                } else {
                  if (widget.onSectionCompleteCallback != null) {
                    widget.onSectionCompleteCallback!();
                  }
                  if (sectionDetail != null && widget.isExpanded) {
                    expanded = widget.isExpanded;
                    expandsionController.expand();
                  } else if (sectionDetail == null && widget.isExpanded) {
                    expandsionController.collapse();
                    showToast(Strings.stageError);
                  }
                  currentLoadingStatus = LoadingStatus.complete;
                }
                if (mounted) {
                  setState(() {});
                }
              });
            },
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  if (sectionDetail == null) {
                    showSnackBar(msg: Strings.sectionError, context: context);
                  }
                },
                child: CustomExpansionTile(
                  initialExpanded: widget.isExpanded,
                  elevation: 0,
                  controller: expandsionController,
                  cardShape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  isExpanded: expanded,
                  enableExpansionTile: sectionDetail != null,
                  onExpansionChanged: (value) async {
                    setState(() => expanded = value);
                  },
                  title: TitleBuilder(
                    isMobile: sizeInfo.isMobile,
                    title:
                        "Section ${widget.index + 1}: ${widget.section.sectionName}",
                  ),
                  trailing: sectionDetail == null
                      ? const Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        )
                      : AnimatedRotation(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 350),
                          turns: expanded ? 1 / 2 : 0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: colorPrimary, // Color
                                      shape: BoxShape.circle),
                                  margin: const EdgeInsets.all(3),
                                ),
                              ),
                              const Icon(Icons.expand_circle_down_outlined)
                            ],
                          ),
                        ),
                  children: [
                    currentLoadingStatus == LoadingStatus.section
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: const CourseDetailsLoaderWidget(),
                          )
                        : currentLoadingStatus == LoadingStatus.error ||
                                sectionDetail == null
                            ? Text(
                                "Unfortunately, this section is locked. You must finish the preceding section in order to learn the following one.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                        runSpacing: 10,
                                        spacing: 15,
                                        runAlignment: WrapAlignment.spaceAround,
                                        children: [
                                          CourseStatusWidget(
                                            icon: CustomIcons.hour,
                                            title: sectionDetail!.totalDuration,
                                            isMobile: sizeInfo.isMobile,
                                          ),
                                          CourseStatusWidget(
                                            icon: CustomIcons.laptop,
                                            title:
                                                "${sectionDetail!.lessonCount} Lessons",
                                            isMobile: sizeInfo.isMobile,
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(height: 15),
                                  sizeInfo.isMobile
                                      ? CourseStatusWidgetMobile(
                                          lessonComplete: sectionDetail!
                                              .lessonCompletedPercentage,
                                          quizComplete: sectionDetail!
                                              .quizCompletedPercentage
                                              .toString(),
                                          quizCorrectAnswer: sectionDetail!
                                              .quizCorrectPercentage
                                              .toString(),
                                          totalHour:
                                              sectionDetail!.hoursTotalSpent,
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                ProgressTile(
                                                  title:
                                                      "${sectionDetail!.lessonCompletedPercentage}${courseProgressList[0]['title']}",
                                                  icon: courseProgressList[0]
                                                      ['icon'],
                                                ),
                                                ProgressTile(
                                                  title:
                                                      "${limitPercentageValue(sectionDetail!.quizCompletedPercentage)}${courseProgressList[1]['title']}",
                                                  icon: courseProgressList[1]
                                                      ['icon'],
                                                ),
                                                ProgressTile(
                                                  title:
                                                      "${limitPercentageValue(sectionDetail!.quizCorrectPercentage)}${courseProgressList[2]['title']}",
                                                  icon: courseProgressList[2]
                                                      ['icon'],
                                                ),
                                                ProgressTile(
                                                  title:
                                                      "${sectionDetail!.hoursTotalSpent}${courseProgressList[3]['title']}",
                                                  icon: courseProgressList[3]
                                                      ['icon'],
                                                )
                                              ]),
                                        ),
                                  const SizedBox(height: 15),
                                  Text(
                                    sectionDetail!.sectionDescription,
                                    textAlign: TextAlign.justify,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(height: 2, fontSize: 15),
                                  ),
                                  const SizedBox(height: 15),
                                  ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (_, i) =>
                                          const SizedBox(height: 15),
                                      shrinkWrap: true,
                                      itemCount: sectionDetail!.videos.length,
                                      itemBuilder: (_, index) {
                                        var video =
                                            sectionDetail!.videos[index];
                                        return InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () => navigateLessonScreen(
                                              currentIndex: index,
                                              video: video),
                                          child: LessonTile(
                                            verticalAlign:
                                                sizeInfo.screenSize.width < 700
                                                    ? true
                                                    : false,
                                            isCompleted: (sectionDetail!
                                                        .videoStatus
                                                        .firstWhereOrNull(
                                                            (element) =>
                                                                element
                                                                    .videoId ==
                                                                video.videoId)
                                                        ?.watchStatus ??
                                                    2) ==
                                                1,
                                            title: video.videoName,
                                            duration: video.videoDuration,
                                            presenter: video.presenter,
                                            titleStyle:
                                                getTextStyle(sizeInfo.isMobile),
                                            subtitleStyle:
                                                getTextStyle(sizeInfo.isMobile),
                                            iconSize: 15,
                                          ),
                                        );
                                      }),
                                  if (sectionDetail!.questionCount > 0)
                                    Column(
                                      children: [
                                        const SizedBox(height: 15),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () => quizTilePress(),
                                          child: SectionTile(
                                            isCompleted:
                                                sectionDetail!.quizResult == 1,
                                            title:
                                                "Section ${widget.index + 1} Review",
                                            subtitle:
                                                "${sectionDetail!.questionCount} Qs",
                                            isMobile: sizeInfo.isMobile,
                                            iconSize: 15,
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              )
                  ],
                ),
              );
            });
      },
    );
  }
}
