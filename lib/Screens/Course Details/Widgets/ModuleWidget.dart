import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Model/SidebarMenuItemModel.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Model/CourseQuizModel.dart';
import 'package:astepup_website/Model/ModuleDetailsModel.dart';
import 'package:astepup_website/Model/StageModel.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Course%20Details/Widgets/CourseDetail.dart';
import 'package:astepup_website/Screens/Screens.dart';

import '../../../Utils/QuizHelper.dart';
import 'SectionWidget.dart';

class ModuleWidget extends StatefulWidget {
  ModuleWidget({
    super.key,
    required this.module,
    required this.index,
    required this.isExpanded,
    this.stageDetail,
    required this.isLocked,
    this.stageEnd = false,
    this.onSectionCompleteCallback,
  });

  final int index;
  bool isExpanded;
  final bool isLocked;
  final Module module;
  final VoidCallback? onSectionCompleteCallback;
  final bool stageEnd;
  final StageQuiz? stageDetail;

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  var currentLoadingStatus = LoadingStatus.section;
  int currentSectionComplete = 0;
  ExpansionTileController expandsionController = ExpansionTileController();
  ModuleDetails? moduleDetails;

  bool expanded = false;

  @override
  void initState() {
    super.initState();
  }

  void quizButtonClick(CourseDetailsController controller) async {
    if (widget.index == 0 &&
        Quizhelper.quizLockStatus(
            MenuType.moduleQuiz, moduleDetails!.toJson())) {
      showSnackBar(msg: Strings.depenedCommonError, context: context);
    } else if (Quizhelper.quizLockStatus(
        MenuType.moduleQuiz, moduleDetails!.toJson())) {
      showSnackBar(msg: Strings.moduleError, context: context);
    } else {
      controller.courseRepository.changeQuizLockStatus(
        stageId: widget.stageDetail!.id.toString(),
        moduleId: moduleDetails!.moduleId.toString(),
      );
      controller.courseRepository.changeExpandedStatus(
        stageId: widget.stageDetail!.id.toString(),
        moduleId: moduleDetails!.moduleId.toString(),
      );
      var selectedKey = controller.courseRepository.findElementKey(
          stageId: widget.stageDetail!.id,
          moduleId: moduleDetails!.moduleId,
          type: MenuType.moduleQuiz);
      context.go('/lesson/module/${moduleDetails!.moduleId}', extra: {
        'cid': getSavedObject(StorageKeys.courseId).toString(),
        'sid': widget.stageDetail!.id.toString(),
        "selectedStageId": "${widget.stageDetail!.id}",
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
            didChangeDependencies: (state) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                moduleDetails = await state.controller?.moduleDetailsAPI(
                    state.controller?.moduleid == null
                        ? widget.module.moduleId.toString()
                        : state.controller!.moduleid.toString(),
                    stageId: widget.stageDetail!.id.toString(),
                    cousreId: getSavedObject(StorageKeys.courseId).toString());
                state.controller?.moduleid = null;
                if (moduleDetails == null) {
                  widget.isExpanded = false;
                  expandsionController.collapse();
                  if (expanded) {
                    expandsionController.collapse();
                    showToast(Strings.moduleError);
                  }
                  currentLoadingStatus = LoadingStatus.error;
                } else {
                  if (widget.onSectionCompleteCallback != null) {
                    widget.onSectionCompleteCallback!();
                  }
                  if (moduleDetails != null && widget.isExpanded) {
                    expandsionController.expand();
                  } else if (moduleDetails == null && widget.isExpanded) {
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
                  if (moduleDetails == null) {
                    showSnackBar(msg: Strings.moduleError, context: context);
                  }
                },
                child: CustomExpansionTile(
                  elevation: 0,
                  controller: expandsionController,
                  enableExpansionTile: moduleDetails != null,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                  cardShape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  isExpanded: expanded,
                  initialExpanded: widget.isExpanded,
                  onExpansionChanged: (value) async {
                    setState(() => expanded = value);
                  },
                  trailing: moduleDetails == null
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
                    title:
                        "Module ${widget.index + 1}: ${widget.module.moduleName}",
                  ),
                  showLoader: controller.currentLoadingStatus ==
                          LoadingStatus.stageLoding &&
                      moduleDetails == null,
                  children: [
                    moduleDetails == null
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
                                        title: moduleDetails!.totalHours,
                                        isMobile: sizeInfo.isMobile,
                                      ),
                                      const SizedBox(width: 10),
                                      CourseStatusWidget(
                                        title:
                                            "${moduleDetails!.sectionCount} Sections",
                                        icon: CustomIcons.section,
                                        isMobile: sizeInfo.isMobile,
                                      ),
                                    ]),
                              ),
                              const SizedBox(height: 15),
                              sizeInfo.isMobile
                                  ? CourseStatusWidgetMobile(
                                      lessonComplete: moduleDetails!
                                          .lessonCompletedPercentage,
                                      quizComplete: moduleDetails!
                                          .quizCompletedPercentage,
                                      quizCorrectAnswer:
                                          moduleDetails!.quizCorrectPercentage,
                                      totalHour: moduleDetails!.hoursTotalSpent,
                                    )
                                  : SizedBox(
                                      height: 50,
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            ProgressTile(
                                              title:
                                                  "${moduleDetails!.lessonCompletedPercentage}${courseProgressList[0]['title']}",
                                              icon: courseProgressList[0]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${limitPercentageValue(moduleDetails!.quizCompletedPercentage)}${courseProgressList[1]['title']}",
                                              icon: courseProgressList[1]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${limitPercentageValue(moduleDetails!.quizCorrectPercentage)}${courseProgressList[2]['title']}",
                                              icon: courseProgressList[2]
                                                  ['icon'],
                                            ),
                                            ProgressTile(
                                              title:
                                                  "${moduleDetails!.hoursTotalSpent}${courseProgressList[3]['title']}",
                                              icon: courseProgressList[3]
                                                  ['icon'],
                                            )
                                          ]),
                                    ),
                              const SizedBox(height: 15),
                              Text(
                                moduleDetails!.moduleDescription,
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
                                  itemCount: moduleDetails!.sections.length,
                                  itemBuilder: (_, i) {
                                    return SectionWidget(
                                      onSectionCompleteCallback: () {
                                        currentSectionComplete =
                                            currentSectionComplete + 1;
                                        if (moduleDetails!.sectionCount ==
                                            currentSectionComplete) {
                                          controller.courseRepository
                                              .changeQuizLockStatus(
                                            stageId: widget.stageDetail!.id
                                                .toString(),
                                            moduleId: moduleDetails!.moduleId
                                                .toString(),
                                          );
                                        } else {
                                          controller.courseRepository
                                              .changeQuizLockStatus(
                                                  stageId: widget
                                                      .stageDetail!.id
                                                      .toString(),
                                                  moduleId: moduleDetails!
                                                      .moduleId
                                                      .toString(),
                                                  quizLockStatus: true);
                                        }
                                        setState(() {});
                                      },
                                      key: ObjectKey(
                                          moduleDetails!.sections[i].sectionId),
                                      section: moduleDetails!.sections[i],
                                      index: i,
                                      totalLength:
                                          moduleDetails!.sections.length,
                                      isLocked: widget.isLocked,
                                      isExpanded: moduleDetails!
                                              .sections[i].sectionId ==
                                          controller.sectionId,
                                      moduleDetails: ModuleQuiz(
                                          id: moduleDetails?.moduleId ?? 1,
                                          quizCount:
                                              moduleDetails?.questionCount ?? 0,
                                          quizTitle:
                                              "Module ${widget.index + 1} Concept Check"),
                                      moduleEnd:
                                          (moduleDetails?.questionCount ?? 0) ==
                                              0,
                                      stageEnd: widget.stageEnd,
                                      stageDetails: widget.stageDetail,
                                    );
                                  }),
                              const SizedBox(height: 15),
                              moduleDetails!.questionCount > 0
                                  ? InkWell(
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () => quizButtonClick(controller),
                                      child: SectionTile(
                                        isCompleted:
                                            moduleDetails!.quizResult == 1,
                                        isLessonLocked:
                                            Quizhelper.quizLockStatus(
                                                MenuType.moduleQuiz,
                                                moduleDetails!.toJson()),
                                        title:
                                            "Module ${widget.index + 1} Concept Check",
                                        subtitle:
                                            "${moduleDetails!.questionCount} Qs",
                                        isMobile: sizeInfo.isMobile,
                                        iconSize: 15,
                                      ),
                                    )
                                  : const SizedBox(),
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
