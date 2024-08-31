import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/colors.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final Alignment? expandedAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Widget? trailing;
  final EdgeInsetsGeometry? tilePadding;
  final ShapeBorder? cardShape;
  final ShapeBorder? expansionTileshape;
  final double? elevation;
  final bool showfillButton;
  final Function(bool)? onExpansionChanged;
  final bool isExpanded;
  final bool showLoader;
  final bool isMobile;
  final bool initialExpanded;
  final ExpansionTileController? controller;
  final bool enableExpansionTile;
  const CustomExpansionTile(
      {super.key,
      required this.title,
      required this.children,
      this.expandedCrossAxisAlignment,
      this.expandedAlignment,
      this.childrenPadding,
      this.trailing,
      this.tilePadding,
      this.cardShape,
      this.expansionTileshape,
      this.elevation = 6,
      this.initialExpanded = false,
      this.showfillButton = true,
      this.onExpansionChanged,
      required this.isExpanded,
      this.showLoader = true,
      this.isMobile = false,
      this.controller,
      this.enableExpansionTile = true});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  // bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: widget.cardShape ??
          RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
      elevation: widget.elevation,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        child: ExpansionTile(
            enabled: widget.enableExpansionTile,
            controller: widget.controller,
            onExpansionChanged: widget.onExpansionChanged,
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            tilePadding: widget.tilePadding,
            childrenPadding: widget.isMobile
                ? const EdgeInsets.symmetric(horizontal: 5, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            expandedCrossAxisAlignment:
                widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.start,
            expandedAlignment: widget.expandedAlignment ?? Alignment.topLeft,
            initiallyExpanded: widget.initialExpanded,
            shape: widget.expansionTileshape ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            collapsedShape: widget.expansionTileshape ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            trailing: Builder(builder: (context) {
              return widget.trailing ??
                  (!widget.showfillButton
                      ? AnimatedRotation(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 350),
                          turns: widget.isExpanded || widget.initialExpanded
                              ? 1 / 2
                              : 0,
                          child: const Icon(Icons.expand_more))
                      : AnimatedRotation(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 350),
                          turns: widget.isExpanded || widget.initialExpanded
                              ? 1 / 2
                              : 0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: colorPrimary, // Color
                                      shape: BoxShape.circle),
                                  margin: const EdgeInsets.all(3),
                                ),
                              ),
                              const Icon(Icons.expand_circle_down_outlined)
                            ],
                          ),
                        ));
            }),
            title: widget.title,
            children:
                //  widget.showLoader
                //     ? [
                //         const Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       ] :
                widget.children),
      ),
    );
  }
}
