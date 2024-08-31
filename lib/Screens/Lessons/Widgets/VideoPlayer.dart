import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../Controller/LessonController.dart';

class VimeoVideoPlayer extends StatefulWidget {
  const VimeoVideoPlayer({
    super.key,
  });

  @override
  State<VimeoVideoPlayer> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer> {
  // @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    initVideo();
  }

  html.IFrameElement iframe = html.IFrameElement();

  String vimeo = 'vimeoplayer';
  void initVideo() {
    ui.platformViewRegistry.registerViewFactory(
      vimeo,
      (int viewId) {
        iframe = html.IFrameElement()
          ..id = 'custom-vimeo-player'
          ..allowFullscreen = true
          ..style.border = 'none'
          ..width = '100%'
          ..style.height = '100%'
          ..style.overflow = 'hidden'
          ..allow = 'autoplay'
          ..src =
              'https://player.vimeo.com/video/${Get.find<LessonController>().extractVideoId(Get.find<LessonController>().videoData!.videoUrl)}&amp;loop=1';

        // wrapper.append(iframe);
        // return wrapper;
        return iframe;
      },
    );
  }

  eventListener(html.IFrameElement iFrameElement) {
    iFrameElement.onPlaying.listen((event) {
      print('playing');
    });
    iFrameElement.onPlay.listen((event) {
      print('play');
    });
    iFrameElement.onPause.listen((event) {
      print('pause');
    });
    iFrameElement.onEnded.listen((event) {
      print('end');
    });
    iFrameElement.addEventListener('onplay', (event) {
      print('palying');
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return GetBuilder<LessonController>(
      initState: (_) {},
      builder: (controller) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              HtmlElementView(
                viewType: vimeo,
                onPlatformViewCreated: (id) {
                  var giveIframe = ui.platformViewRegistry.getViewById(id)
                      as html.IFrameElement;
                  eventListener(giveIframe);
                },
              ),
              MouseRegion(
                onEnter: (_) {
                  controller.enableScroll.value = true;
                },
                onHover: (_) async {
                  await Future.delayed(const Duration(milliseconds: 200), () {
                    controller.enableScroll.value = false;
                  });
                  await Future.delayed(const Duration(seconds: 1), () {
                    controller.enableScroll.value = true;
                  });
                },
                onExit: (_) {
                  controller.enableScroll.value = true;
                },
                child: Obx(
                  () {
                    return PointerInterceptor(
                        intercepting: controller.enableScroll.value,
                        child: Container(
                          color: Colors.transparent,
                        ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
