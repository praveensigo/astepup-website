import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final int percentage;
  const CustomTooltip({Key? key, required this.percentage}) : super(key: key);

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with WidgetsBindingObserver {
  bool _isTooltipVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Detect when app metrics change (e.g., orientation or screen size changes)
  @override
  void didChangeMetrics() {
    if (_isTooltipVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      _isTooltipVisible = false;
    }
  }

  void _showCustomTooltip(BuildContext context, Offset offset) {
    _isTooltipVisible = true;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx - 155, // Center tooltip over icon
              top: offset.dy + 10, // Position slightly below icon
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CustomPaint(
                      painter: TrianglePainter(),
                      child: const SizedBox(
                        width: 20,
                        height: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Pass: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.green),
                                  ),
                                  TextSpan(
                                    text: "${widget.percentage}% and above",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Fail: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: "Below ${widget.percentage}%",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isTooltipVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _showCustomTooltip(context, details.globalPosition);
      },
      child: const SizedBox(
        width: 24,
        height: 24,
        child: Icon(Icons.info_outline_rounded),
      ),
    );
  }
}

// Custom painter to draw a triangle for the tooltip arrow
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white; // Arrow color set to white
    final Path path = Path();

    path.moveTo(size.width / 2, 0); // Start at the top center
    path.lineTo(0, size.height); // Draw to bottom left
    path.lineTo(size.width, size.height); // Draw to bottom right
    path.close(); // Complete the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
