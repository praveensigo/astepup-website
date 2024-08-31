import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:astepup_website/Resource/Strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:astepup_website/ApiClient/ApiClient.dart';
import 'package:astepup_website/Config/ApiConfig.dart';
import 'package:astepup_website/Model/VideoDetailsModel.dart';
import 'package:astepup_website/Utils/Utils.dart';

import '../../../Utils/webDownload.dart';

class PdfItemWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? textpadding;
  final BoxFit? fit;
  final TextStyle? textStyle;
  final Pdf pdf;
  const PdfItemWidget(
      {super.key,
      this.width,
      this.height,
      this.fit,
      this.textpadding,
      this.textStyle,
      required this.pdf});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(ApiConfigs.imageUrl + pdf.pdf));
      },
      child: Container(
        width: size.width * .06,
        constraints: const BoxConstraints(minWidth: 150, minHeight: 180),
        height: size.width * .02,
        margin: const EdgeInsets.only(right: 10),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 150),
                  child: Image.asset(
                    'Assets/Images/pdf.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: textpadding ??
                    const EdgeInsets.only(
                        left: 10, top: 5, right: 10, bottom: 14),
                child: Text(
                  pdf.resourceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadPdf(Pdf pdf) async {
    try {
      DioInspector inspector = DioInspector(Dio());

      var response = await inspector.send<dynamic>(
          RequestOptions(
            method: 'GET',
            path: ApiConfigs.imageUrl + pdf.pdf,
            responseType: ResponseType.bytes,
          ),
          responseType: ResponseType.bytes);
      if (response.statusCode == 200) {
        downloaderForWeb(
            Uint8List.fromList(response.data), "${pdf.resourceName}.pdf");
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

Future<Uint8List> readPdfAsBytes(String assetPath) async {
  try {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  } catch (e) {
    print('Error reading PDF: $e');
    throw Exception('Failed to read PDF file');
  }
}
