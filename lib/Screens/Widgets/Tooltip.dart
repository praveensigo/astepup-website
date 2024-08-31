// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';


// class Plusfour extends StatefulWidget {
//   final String data;
//   final int length;
//   const Plusfour({Key? key, required this.data, required this.length})
//       : super(key: key);

//   @override
//   State<Plusfour> createState() => _PlusfourState();
// }

// class _PlusfourState extends State<Plusfour> {
//   final _controller = SuperTooltipController();
//   Future<bool> _willPopCallback() async {
//     if (_controller.isVisible) {
//       await _controller.hideTooltip();
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String lang = (widget.length - 2).toString();

//     return widget.length >= 3
//         ? WillPopScope(
//             onWillPop: _willPopCallback,
//             child: GestureDetector(
//               onTap: () async {
//                 await _controller.showTooltip();
//               },
//               child: SuperTooltip(
//                   shadowBlurRadius: 0,
//                   shadowColor: Colors.white,
//                   showBarrier: true,
//                   controller: _controller,
//                   popupDirection: TooltipDirection.down,
//                   backgroundColor: Colors.white,
//                   arrowTipDistance: 0.0,
//                   arrowBaseWidth: 15.0,
//                   arrowLength: 20.0,
//                   borderRadius: 0,
//                   borderColor: Colors.white,
//                   constraints: const BoxConstraints(
//                     minHeight: 0.0,
//                     maxHeight: double.infinity,
//                     minWidth: 0.0,
//                     maxWidth: double.infinity,
//                   ),
//                   showCloseButton: ShowCloseButton.none,
//                   touchThroughAreaShape: ClipAreaShape.rectangle,
//                   barrierColor: const Color.fromARGB(26, 47, 45, 47),
//                   content: SizedBox(
//                     height: 20,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           widget.data,
//                           softWrap: true,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontFamily: 'Poppins-Regular'),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             _controller.hideTooltip();
//                           },
//                           child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.close,
//                                   size: 20,
//                                 ),
//                               )),
//                         )
//                       ],
//                     ),
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(color: colorPrimaryDark)),
//                     width: 19,
//                     height: 19,
//                     child: Center(
//                         child: Text(
//                       "+$lang",
//                       style: const TextStyle(
//                           color: colorPrimaryDark,
//                           fontSize: 12,
//                           fontFamily: 'Poppins-Regular'),
//                     )),
//                   )),
//             ),
//           )
//         : Container();
//   }

//   void makeTooltip() {
//     _controller.showTooltip();
//   }
// }
