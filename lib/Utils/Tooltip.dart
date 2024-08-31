import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CustomTooltip extends StatefulWidget {
  final String percentage;
  const CustomTooltip({super.key, this.percentage = "50"});

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final _controller = SuperTooltipController();
  Future<bool> _willPopCallback() async {
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () async {
          await _controller.showTooltip();
        },
        child: SuperTooltip(
            shadowBlurRadius: 0,
            shadowColor: Colors.white,
            showBarrier: true,
            controller: _controller,
            popupDirection: TooltipDirection.down,
            backgroundColor: Colors.white,
            arrowTipDistance: 0.0,
            arrowBaseWidth: 15.0,
            arrowLength: 20.0,
            borderRadius: 0,
            minimumOutsideMargin: 0,
            borderColor: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 0.0,
              maxHeight: double.infinity,
              minWidth: 0.0,
              maxWidth: double.infinity,
            ),
            showCloseButton: false,
            touchThroughAreaShape: ClipAreaShape.rectangle,
            barrierColor: const Color.fromARGB(26, 47, 45, 47),
            content: SizedBox(
              width: 160,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Pass: ',
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        TextSpan(
                          text: "50% and above",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Fail: ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                        TextSpan(
                          text: "Below 50% ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _controller.hideTooltip();
                    },
                    child: Container(),
                  )
                ],
              ),
            ),
            child: const SizedBox(
                width: 19,
                height: 19,
                child: Icon(Icons.info_outline_rounded))),
      ),
    );
  }

  void makeTooltip() {
    _controller.showTooltip();
  }
}
