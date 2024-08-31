import 'dart:typed_data';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/QuizController.dart';
import 'package:astepup_website/Resource/Strings.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:astepup_website/Screens/Mastery/widget/PdfView.dart';
import 'package:astepup_website/Screens/Screens.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:go_router/go_router.dart';
import 'package:astepup_website/Utils/webDownload.dart';

class MasteryViewCertificate extends StatefulWidget {
  const MasteryViewCertificate({super.key});

  @override
  State<MasteryViewCertificate> createState() => _MasterViewyCertificateState();
}

class _MasterViewyCertificateState extends State<MasteryViewCertificate> {
  final formKey = GlobalKey<FormState>();

  TextEditingController feedback = TextEditingController();
  bool isDownloading = false;
  String courseTitle = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      init: QuizController(),
      initState: (_) {},
      didChangeDependencies: (state) {
        if (state.controller!.courseName.isNotEmpty) {
          courseTitle = state.controller?.courseName ?? "";
        } else if (getSavedObject(StorageKeys.quizData) != null) {
          courseTitle =
              getSavedObject(StorageKeys.quizData)['quiz_title'] ?? "";
        } else {
          courseTitle = (getSavedObject('courseName') ?? '');
        }
      },
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width < 540 ? 30 : 65, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Center(
                        child: PdfViewerPage(
                      apiUrl:
                          '${ApiConfigs.baseUrl + ApiEndPoints.courseCertificate}?course_id=${getSavedObject(StorageKeys.courseId)}',
                    )),
                    const SizedBox(height: 20),
                    Center(
                      child: isDownloading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: size.width < 540
                                    ? const Size(250, 50)
                                    : const Size(400, 50),
                              ),
                              onPressed: () async {
                                isDownloading = true;
                                setState(() {});
                                await downloadPdf();
                                isDownloading = false;
                                setState(() {});
                              },
                              child: Text(
                                "DownLOAD CERTIFICATE".toUpperCase(),
                                style: size.width < 590
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                              )),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: SizedBox(
                        width: size.width * .6,
                        child: TextFormField(
                          maxLines: 12,
                          controller: feedback,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter you feedback";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "Feedback here",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: borderColorDark)),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        spacing: 15.0,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: size.width < 540
                                    ? const Size(140, 50)
                                    : const Size(180, 50),
                              ),
                              onPressed: () async {
                                var controller = Get.find<LessonController>();
                                if (formKey.currentState!.validate()) {
                                  FormData data = FormData.fromMap({
                                    "feedback": feedback.text.trim(),
                                    "course_id":
                                        getSavedObject(StorageKeys.courseId),
                                  });
                                  await controller.updateUserFeedback(
                                      endPoint:
                                          ApiEndPoints.updateCourseFeedback,
                                      data: data);
                                  feedback.clear();
                                }
                              },
                              child: Text(
                                "SEND".toUpperCase(),
                                style: size.width < 590
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: size.width < 540
                                    ? const Size(140, 50)
                                    : const Size(180, 50),
                              ),
                              onPressed: () {
                                html.window.history
                                    .replaceState(null, "home", "/");
                                context.pushReplacement('/');
                              },
                              child: Text(
                                "Home".toUpperCase(),
                                style: size.width < 590
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold)
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadPdf() async {
    try {
      DioInspector inspector = DioInspector(Dio());
      var body = {"course_id": getSavedObject(StorageKeys.courseId)};
      var response = await inspector.send<dynamic>(
          RequestOptions(
            method: 'GET',
            path: ApiConfigs.baseUrl + ApiEndPoints.courseCertificate,
            responseType: ResponseType.bytes,
            queryParameters: body,
          ),
          responseType: ResponseType.bytes);
      if (response.statusCode == 200) {
        var name = (getSavedObject(StorageKeys.quizData) ?? {})
                .containsKey('quiz_title')
            ? getSavedObject(StorageKeys.quizData)['quiz_title']
            : getSavedObject('courseName');
        downloaderForWeb(
            Uint8List.fromList(response.data), "Certificate-$name.pdf");
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
