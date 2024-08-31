import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Widgets/appbar.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:astepup_website/Utils/webDownload.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../Widgets/UserInputFeild.dart';

class ViewCertificates extends StatefulWidget {
  const ViewCertificates(
      {super.key, required this.courseName, required this.courseId});

  final String courseId;
  final String courseName;

  @override
  State<ViewCertificates> createState() => _ViewCertificatesState();
}

class _ViewCertificatesState extends State<ViewCertificates> {
  String courseName = '';
  TextEditingController feedBackController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.courseName.isNotEmpty) {
      savename('courseName', widget.courseName);
    }
    // courseName = widget.courseName.isEmpty;
    super.initState();
  }

  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final textFieldBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor, width: 1.4),
        borderRadius: BorderRadius.circular(6));
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return CertificateMobileView(
            sizingInformation: sizingInformation,
            courseId: widget.courseId,
            courseName:
                courseName.isEmpty ? getSavedObject('courseName') : courseName,
          );
        }
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              courseName.isEmpty
                                  ? getSavedObject('courseName')
                                  : courseName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            height: (sizingInformation.screenSize).width * 0.34,
                            child: SfPdfViewer.network(
                                '${ApiConfigs.baseUrl + ApiEndPoints.courseCertificate}?course_id=${widget.courseId}',
                                canShowScrollHead: false,
                                canShowScrollStatus: false,
                                headers: {
                                  "Authorization":
                                      "Bearer ${getSavedObject('token')}"
                                },
                                enableDoubleTapZooming: false,
                                enableTextSelection: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isDownloading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          isDownloading = true;
                                          setState(() {});
                                          await CertificateAPI.downloadPdf(
                                              widget.courseId,
                                              "${courseName.isEmpty ? getSavedObject('courseName') : courseName}");
                                          isDownloading = false;
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(200, 50),
                                            maximumSize: const Size(300, 50),
                                            backgroundColor: colorPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    color:
                                                        Colors.grey.shade400))),
                                        child: Text(
                                          "DOWNLOAD CERTIFICATE",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: sizingInformation.isDesktop
                                              ? textTheme.bodyLarge!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)
                                              : textTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                        )),
                                  ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .3,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    context.go('/detail/${widget.courseId}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50),
                                      maximumSize: const Size(400, 50),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: Colors.grey.shade400))),
                                  child: Text(
                                    "VIEW COURSE DETAILS",
                                    style: sizingInformation.isDesktop
                                        ? textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)
                                        : textTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  )),
                            ),
                            Form(
                              key: formKey,
                              child: UserInputField(
                                title: "",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your feedback";
                                  }
                                  return null;
                                },
                                controller: feedBackController,
                                maxLines: sizingInformation.isTablet ? 5 : 10,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Feedback here",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.grey),
                                    border: textFieldBorder,
                                    enabledBorder: textFieldBorder,
                                    focusedBorder: textFieldBorder),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .3,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      FormData data = FormData.fromMap({
                                        "feedback":
                                            feedBackController.text.trim(),
                                        "course_id": widget.courseId,
                                      });
                                      await CertificateAPI.updateUserFeedback(
                                          endPoint:
                                              ApiEndPoints.updateCourseFeedback,
                                          bodyData: data);
                                      feedBackController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(180, 50),
                                      maximumSize: const Size(400, 50),
                                      backgroundColor: colorPrimary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: Colors.grey.shade400))),
                                  child: Text(
                                    "SEND",
                                    style: !sizingInformation.isDesktop
                                        ? textTheme.bodyMedium!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)
                                        : textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class CertificateMobileView extends StatefulWidget {
  CertificateMobileView(
      {super.key,
      required this.sizingInformation,
      required this.courseName,
      required this.courseId});

  final String courseId;
  final String courseName;
  final SizingInformation sizingInformation;

  @override
  State<CertificateMobileView> createState() => _CertificateMobileViewState();
}

class _CertificateMobileViewState extends State<CertificateMobileView> {
  final TextEditingController feedBackController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final textFieldBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor, width: 1.4),
        borderRadius: BorderRadius.circular(6));
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.course,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(
              height: 270,
              child: SfPdfViewer.network(
                '${ApiConfigs.baseUrl + ApiEndPoints.courseCertificate}?course_id=${widget.courseId}',
                headers: {"Authorization": "Bearer ${getSavedObject('token')}"},
                enableDoubleTapZooming: false,
                enableTextSelection: false,
                canShowScrollHead: false,
                canShowScrollStatus: false,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isDownloading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          isDownloading = true;
                          setState(() {});
                          await CertificateAPI.downloadPdf(
                              widget.courseId, widget.courseName);
                          isDownloading = false;
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            maximumSize: const Size(400, 50),
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.grey.shade400))),
                        child: Text(
                          "DOWNLOAD",
                          style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                ElevatedButton(
                    onPressed: () async {
                      context.go('/detail/${widget.courseId}');
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50),
                        maximumSize: const Size(400, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.grey.shade400))),
                    child: Text(
                      "VIEW DETAILS",
                      style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formKey,
              child: UserInputField(
                title: "",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your feedback";
                  }
                  return null;
                },
                maxLines: 4,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Feedback here",
                    hintStyle: const TextStyle(color: Colors.black),
                    border: textFieldBorder,
                    enabledBorder: textFieldBorder,
                    focusedBorder: textFieldBorder),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      FormData bodyData = FormData.fromMap({
                        "feedback": feedBackController.text.trim(),
                        "course_id": widget.courseId,
                      });
                      await CertificateAPI.updateUserFeedback(
                          endPoint: ApiEndPoints.updateCourseFeedback,
                          bodyData: bodyData);
                      feedBackController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      maximumSize: const Size(400, 50),
                      backgroundColor: colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey.shade400))),
                  child: Text(
                    "SEND",
                    style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateAPI {
  static DioInspector inspector = DioInspector(Dio());

  static Future<void> downloadPdf(String courseId, String courseName) async {
    try {
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
        downloaderForWeb(
            Uint8List.fromList(response.data), "Certificate-$courseName.pdf");
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

  static Future<String?> updateUserFeedback(
      {required String endPoint, required FormData bodyData}) async {
    try {
      var url = ApiConfigs.baseUrl + endPoint;

      var response = await inspector.send<dynamic>(
        RequestOptions(method: 'POST', path: url, data: bodyData),
      );
      if (response.statusCode == 200) {
        showToast(response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data['message'] is Map<String, dynamic>) {
          Map<String, dynamic> message = e.response?.data['message'];
          debugPrint(message.toString());
        } else {
          debugPrint(e.response?.data);
        }
      } else {
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
