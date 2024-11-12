import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CustomTooltip extends StatefulWidget {
  final int percentage;
  const CustomTooltip({super.key, required this.percentage});

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
            minimumOutsideMargin: 00,
            borderColor: Colors.white,
            // showCloseButton: ShowCloseButton.none,
            touchThroughAreaShape: ClipAreaShape.rectangle,
            barrierColor: const Color.fromARGB(26, 47, 45, 47),
            content: SizedBox(
              width: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pass: ',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.green,
                                  ),
                        ),
                        TextSpan(
                            text: "${widget.percentage}% and above",
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fail: ',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                        TextSpan(
                            text: "Below ${widget.percentage}%",
                            style: Theme.of(context).textTheme.bodyMedium!),
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
