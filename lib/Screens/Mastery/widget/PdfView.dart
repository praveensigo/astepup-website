import 'package:flutter/material.dart';
import 'package:astepup_website/Utils/Utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String apiUrl;
  PdfViewerPage({super.key, required this.apiUrl});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool error = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints(maxHeight: 350, maxWidth: 500),
          width: size.width * .6,
          height: sizeInfo.isMobile ? 200 : size.height * .8,
          child: error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_outlined,
                      size: 45,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "There was an error loading the certificate.\n Please refresh the page and try again.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : SfPdfViewer.network(widget.apiUrl,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  headers: {
                      "Authorization": "Bearer ${getSavedObject('token')}"
                    }, onDocumentLoadFailed: (details) {
                  error = true;
                  setState(() {});
                },
                  currentSearchTextHighlightColor:
                      const Color.fromARGB(255, 255, 255, 255),
                  otherSearchTextHighlightColor:
                      const Color.fromARGB(255, 255, 255, 255),
                  enableDoubleTapZooming: false,
                  enableTextSelection: false),
        ),
      );
    });
  }
}
