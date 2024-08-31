import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:astepup_website/Controller/LessonController.dart';
import 'package:astepup_website/Controller/SidebarManager.dart';
import 'package:astepup_website/Resource/CustomIcons.dart';
import 'package:astepup_website/Screens/Screens.dart';

import 'Widgets/Sidebar/flutter_sidebar.dart';

class LessonScaffold extends StatefulWidget {
  const LessonScaffold({
    super.key,
    this.appBar,
    // this.sideBar,
    required this.body,
    this.backgroundColor,
  });

  final PreferredSizeWidget? appBar;
  // final LesssonSideBar? sideBar;
  final Widget body;
  final Color? backgroundColor;

  @override
  State<LessonScaffold> createState() => _LessonScaffoldState();
}

class _LessonScaffoldState extends State<LessonScaffold>
    with SingleTickerProviderStateMixin {
  static const _mobileThreshold = 950.0;
  late AnimationController _animationController;
  late Animation _animation;
  bool _isMobile = false;
  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    if (_screenWidth == mediaQuery.size.width) {
      return;
    }

    setState(() {
      _isMobile = mediaQuery.size.width < _mobileThreshold;
      _animationController.value = _isMobile ? 0 : 1;
      _screenWidth = mediaQuery.size.width;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final sideMenuManager = Get.find<SideMenuManager>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LessonController>(
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          backgroundColor: widget.backgroundColor,
          appBar: const CustomAppBar(),
          body: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: widget.body,
                  ),
                ),
                ClipRect(
                  child: SizedOverflowBox(
                    size: Size((400.00) * _animation.value, double.infinity),
                    child: LesssonSideBar(
                      width: (400.00) * _animation.value,
                      height: double.infinity,
                      onTabChanged: (value) {
                        if (sideMenuManager.sideBarController.searchItemIndex(
                                sideMenuManager.sideBarController.tabs[0],
                                value) !=
                            null) {
                          sideMenuManager.sideBarController.selectItem(value);
                        }
                      },
                      controller: sideMenuManager.sideBarController,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionTimeBuilder extends StatelessWidget {
  final String duration;
  const SectionTimeBuilder({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          CustomIcons.playtime,
          width: 20,
        ),
        const SizedBox(width: 7),
        Text(
          duration,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }
}
