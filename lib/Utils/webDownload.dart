import 'dart:convert';
import 'dart:html' as html;
// import 'dart:html';
import 'dart:typed_data';

Future<void> downloaderForWeb(Uint8List bytesData, String fileName) async {
  final content = base64Encode(bytesData);
  html.AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    ..setAttribute("download", fileName)
    ..click();
}
