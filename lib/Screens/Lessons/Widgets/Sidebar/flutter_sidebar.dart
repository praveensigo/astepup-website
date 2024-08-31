import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Repository/CourseRepository.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:astepup_website/Utils/QuizHelper.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Controller/LessonController.dart';
import '../../../../Controller/SidebarManager.dart';
import '../SideBarLoader.dart';
import '../../../../Model/SidebarMenuItemModel.dart';
import '../../../../Repository/SidebarRepository.dart';

class LesssonSideBar extends StatelessWidget {
  LesssonSideBar({
    super.key,
    this.onTabChanged,
    this.width = 400.0,
    this.height = 1000,
    required this.controller,
  });

  final SidebarController controller;
  final double height;
  final ValueChanged<String>? onTabChanged;
  final double width;

  bool isExpanded = false;
  var lessonController = Get.find<LessonController>();
  final courseRepository = CourseRepository();
  bool selected = false;
  final sideBarService = SidebarRepository();
  var sideMenuController = Get.find<SideMenuManager>();
  final AutoScrollController _scrollController = AutoScrollController();

  void scrollToKey(String key) async {
    int index = _findIndexByKey(key);
    if (index != -1) {
      await _scrollController.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin);
      _scrollController.highlight(index);
    }
  }

  int _findIndexByKey(String key) {
    int index = 0;
    for (var stage in controller.tabs) {
      if (stage!.key == key) {
        return index;
      }
      index++;
      for (var module in stage.children) {
        if (module!.key == key) {
          return index;
        }
        index++;
        for (var section in module.children) {
          if (section!.key == key) {
            return index;
          }
          index++;
          // for (var video in section.children) {
          //   if (video!.key == key) {
          //     return index;
          //   }
          //   index++;
          // }
        }
      }
    }
    return -1;
  }

  Future<bool?> onExpansionAPICall(SideMenuItem item) async {
    if (item.type == MenuType.stage) {
      return await sideBarService.getStageItems(item);
    }
    if (item.type == MenuType.module) {
      return await sideBarService.getModuleItems(item);
    }
    if (item.type == MenuType.section) {
      return await sideBarService.getSectionItems(item);
    }
    return null;
  }

  Future<void> updateVideoTile(SideMenuItem tab, BuildContext context) async {
    var lessonController = Get.find<LessonController>();
    var videoid = tab.currentData["videoData"]['video_id'].toString();
    var videoStatus = tab.currentData["videoStauts"]['watch_status'];
    if (GoRouter.of(context).routeInformationProvider.value.uri.toString() !=
        "/lesson") {
      context.go('/lesson', extra: {
        "vid": videoid,
      });
    }
    savename(StorageKeys.lessonIndex, tab.currentIndex + 1);
    savename(StorageKeys.videoId, videoid);
    lessonController.changeVideo(videoid, tab.currentIndex + 1);
    if (videoStatus != 1) {
      await lessonController.courseRepository.updateVideoStatus(
        stageId: tab.idMapper!.stageId.toString(),
        moduleId: tab.idMapper!.moduleId.toString(),
        sectionId: tab.idMapper!.sectionId.toString(),
        cousreId: tab.idMapper!.courseId.toString(),
        videoId: videoid,
      );
    }
  }

  Widget buildTile(SideMenuItem? tab, BuildContext context) {
    if (tab != null) {
      if (tab.type == MenuType.stage ||
          tab.type == MenuType.module ||
          tab.type == MenuType.section) {
        return _buildExpansionTile(tab, context);
      } else if (tab.type == MenuType.unvaild) {
        return _buildInValidTileWidget(tab);
      } else if (tab.type == MenuType.video) {
        return _buildVideoTileWidget(tab, context);
      } else if (tab.type == MenuType.sectionQuiz ||
          tab.type == MenuType.moduleQuiz ||
          tab.type == MenuType.stageQuiz ||
          tab.type == MenuType.finalMasteryQuiz) {
        return _buildQuizTileWidget(tab, context);
      }
    }
    return const SizedBox.shrink();
  }

  void _onTabSelected(String title) {
    if (controller.searchItemIndex(controller.tabs[0], title) != null) {
      controller.selectedTitleNotifier.value = title;
      onTabChanged?.call(title);
    }
  }

  Widget _buildInValidTileWidget(SideMenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: item.title,
    );
  }

  Widget _buildQuizTileWidget(SideMenuItem tab, BuildContext context) {
    return ListTile(
      title: SectionTile(
        isLessonPage: true,
        isCompleted: Quizhelper.quizCompleteStatus(tab.type, tab.currentData),
        iconSize: 17,
        isLessonLocked: Quizhelper.quizLockStatus(tab.type, tab.currentData),
        title: tab.titleString ?? "",
        subtitle: "${tab.currentData['question_count'] ?? 0} Qs",
      ),
      onTap: () {
        if (!Quizhelper.quizLockStatus(tab.type, tab.currentData)) {
          scrollToKey(tab.key);
          savename(StorageKeys.selectedKey, tab.key);
          sideMenuController.selectedItem = tab;
          sideMenuController.selectedItemKeyUrl = tab.key;
          savename(StorageKeys.selectedKey, tab.key);
          lessonController.selectedRoute.value = tab.titleString ?? "";
          sideMenuController.update();
          Get.find<QuizController>().isLoading.value = true;
          if (tab.type == MenuType.sectionQuiz) {
            Map<String, dynamic>? section =
                Get.find<SideMenuManager>().getSectionById(tab.id);
            List<dynamic> videoWatchStatus = section?['video_status'] ?? [];
            var videoStatus = videoWatchStatus
                .firstWhereOrNull((e) => e['watch_status'] == 2);
            if (videoStatus == null) {
              if (context.mounted) {
                _onTabSelected(tab.key);
                navigateToFunction('/lesson/section/${tab.id}', context, tab);
              }
            } else {
              showToast(Strings.lessonError);
              return;
            }
          }
          if (tab.type == MenuType.moduleQuiz) {
            if (context.mounted) {
              navigateToFunction('/lesson/module/${tab.id}', context, tab);
            }
          }
          if (tab.type == MenuType.stageQuiz) {
            if (context.mounted) {
              navigateToFunction('/lesson/stage/${tab.id}', context, tab);
            }
          }
          if (tab.type == MenuType.finalMasteryQuiz) {
            if (context.mounted) {
              navigateToFunction(
                  '/lesson/mastery/${getSavedObject(StorageKeys.courseId)}',
                  context,
                  tab);
            }
          }
          _onTabSelected(tab.key);
        } else {
          if (tab.type == MenuType.sectionQuiz ||
              tab.type == MenuType.moduleQuiz ||
              tab.type == MenuType.stageQuiz) {
            showSnackBar(msg: Strings.depenedCommonError, context: context);
            return;
          }
        }
      },
      selected: controller.selectedTitle == tab.key,
      selectedTileColor: Colors.grey.withOpacity(0.4),
    );
  }

  Widget _buildVideoTileWidget(SideMenuItem tab, BuildContext context) {
    return ListTile(
      title: tab.title,
      onTap: () {
        _onTabSelected(tab.key);
        scrollToKey(tab.key);
        savename(StorageKeys.selectedKey, tab.key);
        sideMenuController.selectedItem = tab;
        sideMenuController.selectedItemKeyUrl = tab.key;
        savename(StorageKeys.selectedKey, tab.key);
        lessonController.selectedRoute.value = tab.titleString ?? "";
        sideMenuController.update();
        Get.find<QuizController>().isLoading.value = true;
        if (tab.type == MenuType.video) {
          updateVideoTile(tab, context);
        }
        var section = tab.currentData["section"];
        var stage = tab.currentData["stage"];
        var module = tab.currentData["module"];
        if (tab.isLastVideo) {
          if ((section['question_count'] ?? 0) == 0) {
            courseRepository.updateUserSectionStatus(
              stageId: tab.idMapper!.stageId.toString(),
              moduleId: tab.idMapper!.moduleId.toString(),
              sectionId: tab.idMapper!.sectionId.toString(),
            );
          }
          if ((module['question_count'] ?? 0) == 0) {
            courseRepository.updateUserModuleStatus(
              tab.idMapper!.stageId.toString(),
              tab.idMapper!.moduleId.toString(),
            );
          }
          if ((stage['question_count'] ?? 0) == 0) {
            courseRepository.updateUserStageStatus(
              tab.idMapper!.stageId.toString(),
            );
          }
        }
      },
      selected: controller.selectedTitle == tab.key,
      selectedTileColor: Colors.grey.withOpacity(0.4),
    );
  }

  bool onlyQuizCheck(SideMenuItem item) {
    final length = item.children.length;
    if (item.children.isNotEmpty) {
      final itemType = item.children.first?.type == MenuType.moduleQuiz ||
          item.children.first?.type == MenuType.sectionQuiz ||
          item.children.first?.type == MenuType.stageQuiz ||
          item.children.first?.type == MenuType.finalMasteryQuiz;
      return length == 1 && itemType;
    }
    return false;
  }

  Widget _buildExpansionTile(SideMenuItem item, BuildContext context) {
    final expandsionController = new ExpansionTileController();
    final itemChildrens =
        item.children.map((child) => buildTile(child, context)).toList();
    return Theme(
      data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(thickness: 2),
          dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: ObjectKey(item.key),
        expansionAnimationStyle: AnimationStyle.noAnimation,
        title: item.title,
        controller: expandsionController,
        onExpansionChanged: (value) async {
          try {
            isExpanded = value;
            if (isExpanded && (onlyQuizCheck(item) || itemChildrens.isEmpty)) {
              item.isExpanded = await onExpansionAPICall(item);
              if (item.isExpanded == null || !item.isExpanded!) {
                item.isExpanded = false;
                expandsionController.collapse();
              }
              if (context.mounted) {
                sideMenuController.update();
                lessonController.update();
              }
            }
          } catch (error) {
            debugPrint(error.toString());
          }
        },
        initiallyExpanded:
            itemChildrens.isEmpty ? false : (item.isExpanded ?? false),
        children: itemChildrens.isEmpty
            ? [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      separatorBuilder: (_, i) => const SizedBox(height: 10),
                      itemCount: 2,
                      itemBuilder: (_, i) {
                        return const SideBarloaderWidget();
                      }),
                ),
              ]
            : itemChildrens,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        child: StreamBuilder<List<SideMenuItem>>(
          stream: sideMenuController.sideBarStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<SideMenuItem> sideBarList = snapshot.data!;
              return ValueListenableBuilder<String?>(
                valueListenable: controller.selectedTitleNotifier,
                builder: (_, value, __) {
                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: sideBarList.length,
                    itemBuilder: (context, index) {
                      final tab = controller.tabs[index];
                      return AutoScrollTag(
                          index: index,
                          key: ValueKey(tab!.key),
                          controller: _scrollController,
                          child: buildTile(tab, context));
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ));
            } else {
              return Center(
                  child: Text(
                "No data available.Please try again",
                style: Theme.of(context).textTheme.bodyLarge,
              ));
            }
          },
        ),
      ),
    );
  }
}

class SidebarController extends ChangeNotifier {
  SidebarController({this.tabs = const []});
  ValueNotifier<String?> selectedTitleNotifier = ValueNotifier<String?>(null);

  String? get selectedTitle => selectedTitleNotifier.value;
  List<SideMenuItem?> tabs;

  void selectItem(String title) {
    selectedTitleNotifier.value = title;
    notifyListeners();
  }

  int? getSelectedIndex() {
    return findItemIndex(tabs, selectedTitle);
  }

  String? getNextItem() {
    final index = getSelectedIndex();
    if (index != null && index < tabs.length - 1) {
      return getFirstSelectableItem(tabs[index + 1]);
    }
    return null;
  }

  String? getPreviousItem() {
    final index = getSelectedIndex();
    if (index != null && index > 0) {
      return getFirstSelectableItem(tabs[index - 1]);
    }
    return null;
  }

  int? findItemIndex(List<SideMenuItem?> tabs, String? title) {
    for (int i = 0; i < tabs.length; i++) {
      final index = searchItemIndex(tabs[i], title);
      if (index != null) return i;
    }
    return null;
  }

  int? searchItemIndex(SideMenuItem? tab, String? title) {
    if (tab?.key == title) return 0;
    for (int i = 0; i < tab!.children.length; i++) {
      final index = searchItemIndex(tab.children[i]!, title);
      if (index != null) return i + 1;
    }
    return null;
  }

  String? getFirstSelectableItem(SideMenuItem? tab) {
    if (tab!.children.isEmpty) {
      return tab.key;
    }
    for (var child in tab.children) {
      final item = getFirstSelectableItem(child!);
      if (item != null) return item;
    }
    return null;
  }
}
