import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/HomeModel.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/Utils/webDownload.dart';

class CoursesCard extends StatelessWidget {
  final Course course;
  final bool isComplete;
  const CoursesCard({super.key, this.isComplete = false, required this.course});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.go('/detail/${course.courseId.toString()}');
      },
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        return Card(
          elevation: 4,
          child: Container(
            width: sizingInformation.deviceScreenType == DeviceScreenType.mobile
                ? size.width * .15
                : sizingInformation.deviceScreenType == DeviceScreenType.tablet
                    ? size.width * .17
                    : size.width * .18,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(10)),
            constraints: BoxConstraints(
                minWidth: 290,
                maxWidth: 360,
                maxHeight: isComplete ? 380 : 350),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CachedNetworkImage(
                      imageUrl: ApiConfigs.imageUrl + course.courseIcon,
                      httpHeaders: const {
                        'Access-Control-Allow-Origin': '*',
                        'Access-Control-Allow-Methods': 'GET, POST',
                        'Access-Control-Allow-Headers': '*',
                      },
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider)),
                      ),
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(AssetManager.errorImage)),
                          ),
                          constraints: const BoxConstraints(maxHeight: 200)),
                    ),
                  ),
                  SizedBox(height: !sizingInformation.isDesktop ? 8 : 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            course.courseName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              height: !sizingInformation.isDesktop ? 8 : 15),
                          Flexible(
                            child: Text(
                              course.courseDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(
                              height: !sizingInformation.isDesktop ? 8 : 15),
                          isComplete
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    savename(StorageKeys.courseId,
                                        course.courseId.toString());
                                    savename("courseName", course.courseName);
                                    if (course.evaluationStatus != null &&
                                        course.evaluationStatus == 1) {
                                      context.go('/evaluation-survey');
                                    } else if (course.evaluationStatus == 2) {
                                      context.go(
                                          '/viewCertificate/${course.courseId.toString()}',
                                          extra: {
                                            "courseName": course.courseName
                                          });
                                    }
                                  },
                                  child: Text(
                                    "View Certificate",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ))
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        );
      }),
    );
  }

  Future<void> getCourseCertificate(String courseId) async {
    try {
      DioInspector inspector = DioInspector(Dio());
      var body = {"course_id": courseId};
      var response = await inspector.send<dynamic>(
          RequestOptions(
            method: 'GET',
            path: ApiConfigs.baseUrl + ApiEndPoints.courseCertificate,
            responseType: ResponseType.bytes,
            queryParameters: body,
          ),
          responseType: ResponseType.bytes);
      if (response.statusCode == 200) {
        downloaderForWeb(Uint8List.fromList(response.data),
            "Certificate-${course.courseName}.pdf");
      } else {
        showToast(Strings.pdfCreationError);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint(e.response?.data);
      }
      showToast(Strings.pdfCreationError);
    }
  }
}
