import 'package:flutter/material.dart';
import 'package:astepup_website/Screens/Lessons/Widgets/ScrollableTabView.dart';

class TabbarBuilder extends StatefulWidget {
  final double? width;
  final List<Widget>? titleWidget;
  final TabController tabController;
  final List<String> tabbarTitleList;
  final List<Widget> tabbarChildren;
  final TextStyle? tabTitleStyle;
  const TabbarBuilder(
      {super.key,
      this.titleWidget,
      this.tabTitleStyle,
      required this.tabController,
      required this.tabbarTitleList,
      required this.tabbarChildren,
      this.width});

  @override
  State<TabbarBuilder> createState() => _TabbarBuilderState();
}

class _TabbarBuilderState extends State<TabbarBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width ?? 280,
          child: TabBar(
              dividerHeight: 4,
              indicatorWeight: 4,
              dividerColor: const Color(0xffD2D2D2),
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              controller: widget.tabController,
              tabs: List.generate(
                widget.tabbarTitleList.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    widget.tabbarTitleList[index],
                    style: widget.tabTitleStyle ??
                        Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ),
        ScrollableTabViewWithController(
            controller: widget.tabController, children: widget.tabbarChildren)
      ],
    );
  }
}
