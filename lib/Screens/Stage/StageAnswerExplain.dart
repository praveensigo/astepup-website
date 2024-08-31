// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:astepup_website/Controller/CourseExplanationController.dart';
// import 'package:astepup_website/Resource/colors.dart';
// import 'package:go_router/go_router.dart';

// class StageAnswerExplain extends StatefulWidget {
//   const StageAnswerExplain({
//     super.key,
//   });

//   @override
//   State<StageAnswerExplain> createState() => _StageAnswerExplainState();
// }

// class _StageAnswerExplainState extends State<StageAnswerExplain> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CourseExplanationController>(
//         init: CourseExplanationController(),
//         initState: (_) {},
//         didChangeDependencies: (state) {
//           state.controller!.explanation("5");
//         },
//         builder: (controller) {
//           return controller.isLoading.value
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     color: colorPrimary,
//                   ),
//                 )
//               : Scaffold(
//                   body: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 35, vertical: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Stage Knowledge Appraisal Summary Page",
//                                   style: Theme.of(context).textTheme.titleLarge,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               OutlinedButton(
//                                 style: OutlinedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(6))),
//                                 child: Text(
//                                   'FEEDBACK',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                                 onPressed: () => feedbackDialog(context),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             "Answer Explanation",
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             controller.questonExplanationModel!.question,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 15),
//                           Text(
//                             controller
//                                 .questonExplanationModel!.answerExplanation,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(),
//                           ),
//                           const SizedBox(height: 20),
//                           Center(
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     // maximumSize: Size(400, 50),
//                                     minimumSize: Size(
//                                         MediaQuery.of(context).size.width / 5,
//                                         50)),
//                                 onPressed: () {
//                                   GoRouter.of(context).pop();
//                                 },
//                                 child: Text(
//                                   "GO BACK",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge!
//                                       .copyWith(fontWeight: FontWeight.bold),
//                                 )),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//         });
//   }

//   void feedbackDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           var size = MediaQuery.of(context).size;
//           return Center(
//               child: Material(
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               constraints: const BoxConstraints(minWidth: 360),
//               width: size.width * .45,
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10), color: Colors.white),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.cancel_outlined,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   Text(
//                     "Feedback",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     maxLines: 5,
//                     decoration: InputDecoration(
//                         hintText: 'Feedback here',
//                         fillColor: Colors.grey[200],
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(color: borderColor),
//                           borderRadius: BorderRadius.circular(15),
//                         )),
//                   ),
//                   const SizedBox(height: 15),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: ElevatedButton(
//                         onPressed: () {}, child: const Text("Send")),
//                   )
//                 ],
//               ),
//             ),
//           ));
//         });
//   }
// }
