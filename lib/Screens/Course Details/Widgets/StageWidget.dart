import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Model/CourseQuizModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/CourseDetail.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Model/CourseDetails.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:shimmer/shimmer.dart';

class StageWidget extends StatefulWidget {
  StageWidget({
    super.key,
    required this.stage,
    required this.index,
    required this.isSelected,
    required this.isLocked,
  });

  final int index;
  final bool isLocked;
  bool isSelected;
  final Stage stage;

  @override
  State<StageWidget> createState() => _StageWidgetState();
}

class _StageWidgetState extends State<StageWidget> {
  int currentModuleComplete = 0;
  ExpansionTileController expandsionController = ExpansionTileController();
  GlobalKey expansionTileKey = GlobalKey();
  StageDetail? stageDetail;

  bool expanded = false;

  @override
  void initState() {
    super.initState();
    getStageData();
  }

  getStageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var controller = Get.find<CourseDetailsController>();
      stageDetail = await controller.stageDetailsAPI(widget.stage.id.toString(),
          cousreId: getSavedObject(StorageKeys.courseId).toString());
      if (stageDetail != null && widget.isSelected) {
        expandsionController.expand();
      } else if (stageDetail == null && widget.isSelected) {
        widget.isSelected = false;
        expandsionController.collapse();
        showToast(Strings.stageError);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  int limitPercentageValue(String numberString) {
    double number = double.parse(numberString);
    int intNumber = number.toInt();
    return intNumber > 100 ? 100 : intNumber;
  }

  void finalQuizButtonClick(CourseDetailsController controller) {
    if (widget.index == 0 &&
        Quizhelper.quizLockStatus(
            MenuType.finalMasteryQuiz, controller.courseDetails!.toJson())) {
      showSnackBar(msg: Strings.depenedCommonError, context: context);
    } else if (Quizhelper.quizLockStatus(
        MenuType.finalMasteryQuiz, controller.courseDetails!.toJson())) {
      showSnackBar(msg: Strings.stageError, context: context);
    } else {
      controller.courseRepository.changeQuizLockStatus(
          courseId: getSavedObject(StorageKeys.courseId).toString());
      controller.courseRepository.changeExpandedStatus(
        stageId: stageDetail!.stageId.toString(),
      );
      String courseId = getSavedObject(StorageKeys.courseId) ?? "";
      context.go('/lesson/mastery/$courseId', extra: {
        "selectedStage": "${stageDetail!.stageId}",
        'selectedKey': getSavedObject(StorageKeys.stageDetails)['final_mastery']
                ['quiz_key'] ??
            ""
      });
    }
  }

  void quizButtonClick(CourseDetailsController controller) {
    if (widget.index == 0 &&
        Quizhelper.quizLockStatus(MenuType.stageQuiz, stageDetail!.toJson())) {
      showSnackBar(msg: Strings.depenedCommonError, context: context);
    } else if (Quizhelper.quizLockStatus(
        MenuType.stageQuiz, stageDetail!.toJson())) {
      showSnackBar(msg: Strings.stageError, context: context);
    } else {
      controller.courseRepository.changeQuizLockStatus(
        stageId: stageDetail!.stageId.toString(),
      );
      controller.courseRepository.changeExpandedStatus(
        stageId: stageDetail!.stageId.toString(),
      );
      var selectedKey = controller.courseRepository.findElementKey(
          stageId: stageDetail!.stageId, type: MenuType.stageQuiz);
      context.go('/lesson/stage/${stageDetail!.stageId}', extra: {
        "selectedStage": "${stageDetail!.stageId}",
        'selectedKey': selectedKey
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return GetBuilder<CourseDetailsController>(
            initState: (_) {},
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  if (stageDetail == null) {
                    showSnackBar(msg: Strings.stageError, context: context);
                  }
                },
                child: CustomExpansionTile(
                  enableExpansionTile: stageDetail != null,
                  isExpanded: expanded,
                  initialExpanded: widget.isSelected,
                  controller: expandsionController,
                  onExpansionChanged: (value) async {
                    setState(() => expanded = value);
                  },
                  trailing: stageDetail == null
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
                  title: TitleBuilder(
                    isMobile: sizeInfo.isMobile,
                    title: "Stage ${widget.index + 1}: ${widget.stage.name}",
                  ),
                  cardShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  showLoader: controller.currentLoadingStatus ==
                          LoadingStatus.stageLoding &&
                      stageDetail == null,
                  children: [
                    stageDetail == null
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: const CourseDetailsLoaderWidget(),
                          )
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
                                        title: stageDetail!.totalHours,
                                        isMobile: sizeInfo.isMobile,
                                      ),
                                      const SizedBox(width: 10),
                                      CourseStatusWidget(
                                        icon: CustomIcons.book,
                                        title:
                                            "${stageDetail!.moduleCount} Modules",
                                        isMobile: sizeInfo.isMobile,
                                      ),
                                      const SizedBox(width: 10),
                                      CourseStatusWidget(
                                        title:
                                            "${stageDetail!.sectionCount} Sections",
                                        icon: CustomIcons.section,
                                        isMobile: sizeInfo.isMobile,
                                      ),
                                    ]),
                              ),
                              const SizedBox(height: 15),
                              sizeInfo.isMobile
                                  ? CourseStatusWidgetMobile(
                                      lessonComplete: stageDetail!
                                          .lessonCompletedPercentage,
                                      quizComplete:
                                          stageDetail!.quizCompletedPercentage,
                                      quizCorrectAnswer:
                                          stageDetail!.quizCorrectPercentage,
                                      totalHour: stageDetail!.hoursTotalSpent,
                                    )
                                  : SizedBox(
                                      height: 50,
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            ProgressTile(
                                              title:
                                                  "${stageDetail!.lessonCompletedPercentage}${courseProgressList[0]['title']}",
                                              icon: courseProgressList[0]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${limitPercentageValue(stageDetail!.quizCompletedPercentage)}${courseProgressList[1]['title']}",
                                              icon: courseProgressList[1]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${limitPercentageValue(stageDetail!.quizCorrectPercentage)}${courseProgressList[2]['title']}",
                                              icon: courseProgressList[2]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${stageDetail!.hoursTotalSpent}${courseProgressList[3]['title']}",
                                              icon: courseProgressList[3]
                                                  ['icon'],
                                            )
                                          ]),
                                    ),
                              const SizedBox(height: 15),
                              Text(
                                stageDetail!.stageDescription,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(height: 2, fontSize: 15),
                              ),
                              const SizedBox(height: 15),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(height: 15),
                                  shrinkWrap: true,
                                  itemCount: stageDetail!.modules.length,
                                  itemBuilder: (_, i) {
                                    return ModuleWidget(
                                        onSectionCompleteCallback: () {
                                          currentModuleComplete =
                                              currentModuleComplete + 1;
                                          if (stageDetail!.moduleCount ==
                                              currentModuleComplete) {
                                            controller.courseRepository
                                                .changeQuizLockStatus(
                                              courseId: getSavedObject(
                                                      StorageKeys.courseId)
                                                  .toString(),
                                              stageId: stageDetail!.stageId
                                                  .toString(),
                                            );
                                          } else {
                                            controller.courseRepository
                                                .changeQuizLockStatus(
                                                    stageId: stageDetail!
                                                        .stageId
                                                        .toString(),
                                                    quizLockStatus: true);
                                          }
                                          setState(() {});
                                        },
                                        isLocked: widget.isLocked,
                                        module: stageDetail!.modules[i],
                                        index: i,
                                        isExpanded:
                                            stageDetail!.modules[i].moduleId ==
                                                controller.moduleid,
                                        stageEnd:
                                            (stageDetail?.questionCount ?? 0) ==
                                                0,
                                        stageDetail: StageQuiz(
                                            id: stageDetail?.stageId ?? 1,
                                            quizCount:
                                                stageDetail?.questionCount ?? 0,
                                            quizTitle:
                                                "Stage ${widget.index + 1} Knowledge Appraisal"));
                                  }),
                              const SizedBox(height: 15),
                              stageDetail!.questionCount > 0
                                  ? InkWell(
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () => quizButtonClick(controller),
                                      child: SectionTile(
                                        isCompleted:
                                            stageDetail!.quizResult == 1,
                                        isLessonLocked:
                                            Quizhelper.quizLockStatus(
                                                MenuType.stageQuiz,
                                                stageDetail!.toJson()),
                                        title:
                                            "Stage ${widget.index + 1} Knowledge Appraisal",
                                        subtitle:
                                            "${stageDetail!.questionCount} Qs",
                                        isMobile: sizeInfo.isMobile,
                                        iconSize: 15,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 7.5),
                              if (widget.index ==
                                      controller.courseDetails!.stages.length -
                                          1 &&
                                  controller.courseDetails!.questionCount > 0)
                                Column(
                                  children: [
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 7.5),
                                    InkWell(
                                      onTap: () =>
                                          finalQuizButtonClick(controller),
                                      child: SectionTile(
                                        isLessonLocked:
                                            Quizhelper.quizLockStatus(
                                                MenuType.finalMasteryQuiz,
                                                controller.courseDetails!
                                                    .toJson()),
                                        isCompleted: controller
                                                .courseDetails!.quizResult ==
                                            1,
                                        title: "Final Mastery Assessment",
                                        subtitle:
                                            "${controller.courseDetails?.questionCount ?? 0} Qs",
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
