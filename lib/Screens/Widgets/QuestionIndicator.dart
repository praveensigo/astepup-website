import 'dart:async';
import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

class QuestionIndicator extends StatefulWidget {
  final List list;
  final int page;
  final Widget? positiveCheck;
  final double height;
  final Duration? durationScroller;
  final Duration? durationCheckBulb;
  final EdgeInsetsGeometry? padding;
  final Function(int)? onClickItem;
  final EdgeInsetsGeometry? paddingLine;
  final int? division;
  final Color? positiveColor;
  final Color? negativeColor;
  final Color? progressColor;
  final Function(int) onChange;

  const QuestionIndicator({
    super.key,
    required this.list,
    required this.page,
    this.positiveCheck,
    required this.height,
    this.durationScroller,
    this.durationCheckBulb,
    this.padding,
    this.onClickItem,
    this.paddingLine,
    this.division,
    this.positiveColor,
    this.negativeColor,
    this.progressColor,
    required this.onChange,
  });

  @override
  State<QuestionIndicator> createState() => _QuestionIndicatorState();
}

class _QuestionIndicatorState extends State<QuestionIndicator> {
  ScrollController controller = ScrollController();
  double maxWidths = 0.0;

  EdgeInsetsGeometry get paddingBulb =>
      (widget.padding != null) ? widget.padding! : EdgeInsets.zero;

  EdgeInsetsGeometry get paddingLine =>
      (widget.paddingLine != null) ? widget.paddingLine! : EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
              shrinkWrap: true,
              controller: controller,
              physics: const NeverScrollableScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                int indexText = index + 1;
                if (index == 0) {
                  return ItemStepIndicatorZero(
                      duration: _currentDurationBulb(),
                      padding: paddingBulb,
                      disableColor: Colors.black,
                      enableColor: Colors.black,
                      progressColor: Colors.black,
                      index: indexText,
                      currentPage: widget.page + 1,
                      height: widget.height,
                      width: widget.height);
                } else {
                  return ItemStepIndicator(
                    duration: _currentDurationBulb(),
                    height: widget.height,
                    paddingLine: paddingLine,
                    padding: paddingBulb,
                    currentPage: widget.page + 1,
                    disableColor: Colors.black,
                    enableColor: Colors.black,
                    progressColor: Colors.black,
                    index: indexText,
                    width: widthIndicator(constraints.maxWidth),
                  );
                }
              });
        },
      ),
    );
  }

  Duration _currentDuration() {
    return (widget.durationScroller == null)
        ? const Duration(milliseconds: 250)
        : widget.durationScroller!;
  }

  Duration _currentDurationBulb() {
    return (widget.durationCheckBulb == null)
        ? const Duration(milliseconds: 250)
        : widget.durationCheckBulb!;
  }

  @override
  void didUpdateWidget(covariant QuestionIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (((widget.list.length * widget.height) > (maxWidths / 2))) {
      if ((widget.page - 2) >= 0 &&
          (widget.page - 2) <= (widget.list.length - 5)) {
        controller.animateTo((widget.page - 2) * widthIndicator(maxWidths),
            duration: _currentDuration(), curve: Curves.decelerate);
      }
    } else {
      // ignore: curly_braces_in_flow_control_structures
      if (((((maxWidths - widget.height) / (widget.list.length - 1)) <
          // ignore: curly_braces_in_flow_control_structures
          (widget.height + 5)))) if ((widget.page - 2) >=
              0 &&
          (widget.page - 2) <= (widget.list.length - 5)) {
        controller.animateTo((widget.page - 2) * widthIndicator(maxWidths),
            duration: _currentDuration(), curve: Curves.decelerate);
      }
    }
    widget.onChange.call(widget.page);
  }

  double widthIndicator(double maxWidth) {
    maxWidths = maxWidth;
    return (((widget.list.length * widget.height) > (maxWidth / 2)))
        ? widthScroller(maxWidth)
        : ((((maxWidth - widget.height) / (widget.list.length - 1)) >
                (widget.height + 5)))
            ? ((maxWidth - widget.height) / (widget.list.length - 1))
            : widthScroller(maxWidth);
  }

  double widthScroller(double maxWidth) {
    return ((maxWidth - widget.height) /
        (((widget.list.length - 1) <= 2)
            ? (widget.list.length - 1)
            : (widget.division == null ||
                    (widget.division! <= 0) ||
                    (widget.division! >= widget.list.length))
                ? 4
                : widget.division!));
  }
}

class ItemStepIndicatorZero extends StatelessWidget {
  final double width;
  final double height;
  final int currentPage;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final int index;
  final Color disableColor;
  final Color progressColor;
  final Color enableColor;

  const ItemStepIndicatorZero({
    super.key,
    required this.height,
    required this.duration,
    required this.padding,
    required this.width,
    required this.currentPage,
    required this.index,
    required this.disableColor,
    required this.progressColor,
    required this.enableColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Center(
        child: CustomPaint(
          size: Size(height, height),
          // painter: (index == currentPage) ? null : CirclePainter(),
          child: Container(
            height: height,
            width: width,
            padding: padding,
            child: AnimatedContainer(
              curve: Curves.easeOutQuint,
              duration: duration,
              decoration: BoxDecoration(
                color: (index == currentPage)
                    ? colorPrimaryDark
                    : const Color(0xff2DA038),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all((index == currentPage) ? 2.5 : 0),
              alignment: Alignment.centerRight,
              child: Center(
                  child: Text(
                "$index",
                style: TextStyle(
                    fontSize: !sizeInfo.isDesktop ? 12 : 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      );
    });
  }
}

class ItemStepIndicator extends StatelessWidget {
  final double width;
  final double height;
  final int currentPage;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry paddingLine;
  final Duration duration;
  final int index;
  final Color disableColor;
  final Color progressColor;
  final Color enableColor;

  const ItemStepIndicator({
    super.key,
    required this.height,
    required this.duration,
    required this.width,
    required this.currentPage,
    required this.paddingLine,
    required this.padding,
    required this.index,
    required this.disableColor,
    required this.progressColor,
    required this.enableColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: padding,
            height: height,
            width: height,
            child: SizedBox(
                child: (index == currentPage)
                    ? _enable(index)
                    : (index < currentPage)
                        ? _done(index)
                        : _disable(index)),
          ),
          Expanded(
              child: Container(
            padding: paddingLine,
            height: height / (height / 4.4),
            child: TweenAnimationBuilder<double>(
                tween: Tween(
                    begin: 0,
                    end: (index == currentPage)
                        ? 1.0
                        : (index < currentPage ? 1.0 : 0.0)),
                curve: Curves.decelerate,
                duration:
                    Duration(milliseconds: duration.inMilliseconds ~/ 1.6),
                builder: (context, value, _) => LayoutBuilder(
                      builder: (context, constraints) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Stack(
                              children: [
                                Visibility(
                                    visible: (index >= currentPage),
                                    child: Container(
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      color: disableColor.withOpacity(0.5),
                                    )),
                                AnimatedContainer(
                                  duration: Duration(
                                      milliseconds:
                                          duration.inMilliseconds ~/ 1.6),
                                  width: (constraints.maxWidth * value),
                                  height: double.maxFinite,
                                  decoration: BoxDecoration(
                                    gradient: (index == currentPage)
                                        ? LinearGradient(
                                            colors: [enableColor, enableColor],
                                            end: Alignment.centerRight,
                                            begin: Alignment.centerLeft)
                                        : (index < currentPage
                                            ? LinearGradient(
                                                colors: [
                                                    enableColor,
                                                    enableColor
                                                  ],
                                                end: Alignment.centerRight,
                                                begin: Alignment.centerLeft)
                                            : LinearGradient(
                                                colors: [
                                                    enableColor
                                                        .withOpacity(0.5),
                                                    disableColor
                                                        .withOpacity(0.5)
                                                  ],
                                                end: Alignment.centerRight,
                                                begin: Alignment.centerLeft)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
          ))
        ],
      ),
    );
  }

  Widget _done(int index) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return AnimatedContainer(
        width: height,
        height: height,
        curve: Curves.easeOutQuint,
        duration: Duration(milliseconds: duration.inMilliseconds),
        decoration: const BoxDecoration(
          color: Color(0xff2DA038),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Center(
            child: Text(
          index.toString(),
          style: TextStyle(
              fontSize: !sizeInfo.isDesktop ? 12 : 15,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )),
      );
    });
  }

  Widget _disable(int index) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return CustomPaint(
        size: Size(height, height),
        painter: CirclePainter(),
        child: AnimatedContainer(
          curve: Curves.easeOutQuint,
          duration: Duration(milliseconds: duration.inMilliseconds),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(2.6),
          alignment: Alignment.centerRight,
          child: Center(
              child: Text(
            index.toString(),
            style: TextStyle(
                fontSize: !sizeInfo.isDesktop ? 12 : 15,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )),
        ),
      );
    });
  }

  Widget _enable(int index) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return AnimatedContainer(
        width: height + 10,
        height: height + 10,
        curve: Curves.easeOutQuint,
        duration: Duration(milliseconds: duration.inMilliseconds),
        decoration: const BoxDecoration(
          color: colorPrimaryDark,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2.5),
        alignment: Alignment.center,
        child: Center(
            child: Text(
          index.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: !sizeInfo.isDesktop ? 12 : 15,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )),
      );
    });
  }
}

class ShowUpAnimationPage extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final int delay;

  const ShowUpAnimationPage(
      {super.key,
      required this.duration,
      required this.child,
      required this.delay});

  @override
  createState() => _ShowUpAnimationPage();
}

class _ShowUpAnimationPage extends State<ShowUpAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: widget.duration);
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, -0.05), end: Offset.zero)
            .animate(curve);
// ignore: unnecessary_null_comparison
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
