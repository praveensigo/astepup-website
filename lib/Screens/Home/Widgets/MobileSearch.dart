import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Controller/CourseDetailsController.dart';
import 'package:astepup_website/Controller/HomeController.dart';
import 'package:astepup_website/Model/HomeSearchModel.dart';
import 'package:astepup_website/Screens/Home/Widgets/Search.dart';

class MobileSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondPage();
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/');
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: HomeSearch(
                        enableMobile: false,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Search Results",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchlist.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      final HomeSearchModel option =
                          controller.searchlist.elementAt(index);
                      final courseName = option.courseName;
                      final stageName = option.stageName;
                      final moduleName = option.moduleName;
                      final sectionName = option.sectionName;
                      return InkWell(
                        onTap: () {
                          CourseDetailsController courseDetailsController =
                              Get.put(CourseDetailsController());
                          courseDetailsController.stageid = option.stageId;
                          courseDetailsController.moduleid = option.moduleId;
                          courseDetailsController.sectionId = option.sectionId;
                          controller.searchlist.clear();
                          context.replace(
                              '/detail/${(option.courseId.toString())}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text(
                              'Course : $courseName',
                            ),
                            subtitle: Text(
                              'Stage: $stageName\nModule: $moduleName\nSection: $sectionName',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
