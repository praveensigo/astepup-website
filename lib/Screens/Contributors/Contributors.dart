import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astepup_website/Controller/ContributorsController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../Widgets/appbar.dart';

class Contributors extends StatelessWidget {
  const Contributors({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
          appBar: CustomAppBar(
            height: sizeInfo.isMobile ? 80 : 120,
          ),
          body: GetBuilder<ContributorsController>(
            init: ContributorsController(),
            didChangeDependencies: (state) {
              state.controller?.getContributors();
            },
            builder: (controller) {
              return ResponsiveBuilder(builder: (context, sizingInformation) {
                return controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.contributorList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Strings.contributors,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 25,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Currently, there are no contributors to display.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 55, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(Strings.contributors,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.contributorList.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 15),
                                          itemBuilder: (_, i) {
                                            return ContributorsItem(index: i);
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
              });
            },
          ));
    });
  }
}

class ContributorsItem extends StatefulWidget {
  final int index;
  const ContributorsItem({super.key, required this.index});

  @override
  State<ContributorsItem> createState() => _ContributorsItemState();
}

class _ContributorsItemState extends State<ContributorsItem> {
  ContributorsController contributorsController =
      Get.put(ContributorsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContributorsController>(
        init: ContributorsController(),
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColorDark),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contributorsController.contributorList[widget.index].name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                contributorsController
                        .contributorList[widget.index].description!.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                              contributorsController
                                  .contributorList[widget.index].description!,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      )
              ],
            ),
          );
        });
  }
}
