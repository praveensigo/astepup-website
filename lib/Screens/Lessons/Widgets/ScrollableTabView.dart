import 'package:flutter/material.dart';

class ScrollableTabViewWithController extends StatefulWidget {
  final TabController controller;
  final List<Widget> children;
  const ScrollableTabViewWithController({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  State<ScrollableTabViewWithController> createState() =>
      _ScrollableTabViewWithControllerState();
}

class _ScrollableTabViewWithControllerState
    extends State<ScrollableTabViewWithController> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.addListener(() {
        index = widget.controller.index;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableTabView(
      selectedIndex: index,
      children: widget.children,
    );
  }
}

class ScrollableTabView extends StatelessWidget {
  final List<Widget> children;
  final int selectedIndex;
  const ScrollableTabView({
    super.key,
    required this.children,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: double.infinity,
      child: children[selectedIndex],
    );
  }
}
