import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Controller/HomeController.dart';
import 'package:astepup_website/Model/HomeSearchModel.dart';

class HomeSearch extends StatefulWidget {
  final bool enableMobile;

  const HomeSearch({
    super.key,
    this.enableMobile = true,
  });

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  bool isScreenOpen = false;
  bool showClearButton = false;
  final homeController = Get.find<HomeController>();

  void handleSelection(HomeSearchModel selection) {
    CourseDetailsController courseDetailsController =
        Get.put(CourseDetailsController());
    courseDetailsController.stageid = selection.stageId;
    courseDetailsController.moduleid = selection.moduleId;
    courseDetailsController.sectionId = selection.sectionId;
    if (GoRouter.of(context)
        .routeInformationProvider
        .value
        .uri
        .toString()
        .contains('/detail/')) {
      GoRouter.of(context)
          .replace('/detail/${(selection.courseId.toString())}');
      GoRouter.of(context).refresh();
    } else {
      GoRouter.of(context)
          .replace('/detail/${(selection.courseId.toString())}');
    }
    Get.find<HomeController>().searchlist.clear();
    debugPrint(
        'You just selected ${selection.sectionId}  ${selection.stageId}   ${selection.moduleId} ${selection.courseId}');
  }

  Iterable<Widget> getHistoryList(SearchController controller) {
    return homeController.searchlist.map((HomeSearchModel searchResult) {
      final courseName = searchResult.courseName;
      final stageName = searchResult.stageName;
      final moduleName = searchResult.moduleName;
      final sectionName = searchResult.sectionName;
      return InkWell(
        onTap: () {
          handleSelection(searchResult);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Course Name: $courseName',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            subtitle: Text(
              'Stage: $stageName\nModule: $moduleName\nSection: $sectionName',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 2, color: Colors.grey[600], letterSpacing: 1),
            ),
          ),
        ),
      );
    });
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return homeController.searchlist.where((model) {
      return model.courseName.toLowerCase().contains(input.toLowerCase()) ||
          model.moduleName.toLowerCase().contains(input.toLowerCase()) ||
          model.sectionName.toLowerCase().contains(input.toLowerCase()) ||
          model.stageName.toLowerCase().contains(input.toLowerCase());
    }).map((HomeSearchModel searchResult) {
      final courseName = searchResult.courseName;
      final stageName = searchResult.stageName;
      final moduleName = searchResult.moduleName;
      final sectionName = searchResult.sectionName;
      return InkWell(
        onTap: () {
          handleSelection(searchResult);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Course Name: $courseName',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            subtitle: Text(
              'Stage: $stageName\nModule: $moduleName\nSection: $sectionName',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 2, color: Colors.grey[600], letterSpacing: 1),
            ),
          ),
        ),
      );
    });
  }

  final SearchController searchController = SearchController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return ResponsiveBuilder(builder: (context, sizeInfo) {
          return SizedBox(
            width: 450,
            child: SearchAnchor.bar(
              barBackgroundColor: WidgetStateProperty.all(Colors.white),
              viewLeading: const SizedBox(),
              onTap: () {
                if (sizeInfo.isMobile && widget.enableMobile) {
                  isScreenOpen = true;
                  GoRouter.of(context).push(
                    '/mobile-search',
                  );
                }
              },
              viewTrailing: [
                IconButton(
                  onPressed: () {
                    if (searchController.value.text.isEmpty) {
                      Navigator.pop(context);
                    } else {
                      controller.searchlist.clear();
                      searchController.clear();
                    }
                  },
                  icon: const Icon(Icons.close),
                )
              ],
              searchController: searchController,
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  await controller.homeSearch(value);
                }
              },
              onSubmitted: (value) async {
                await controller.homeSearch(value);
              },
              barHintText: 'Search',
              barElevation: WidgetStateProperty.all(0),
              barShape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              viewShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                if (controller.text.isEmpty ||
                    homeController.searchlist.isEmpty) {
                  if (homeController.searchlist.isNotEmpty) {
                    return getHistoryList(controller);
                  }
                  return <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Text('No result found.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ];
                }
                return getSuggestions(controller);
              },
            ),
          );
        });
      },
    );
  }
}
