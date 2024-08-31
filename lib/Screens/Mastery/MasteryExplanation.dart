// import 'package:flutter/material.dart';
// import 'package:astepup_website/Resource/AssetsManger.dart';
// import 'package:astepup_website/Resource/colors.dart';
// import 'package:astepup_website/Screens/Widgets/LessonSections.dart';
// import 'package:go_router/go_router.dart';

// class MasteryExplenation extends StatelessWidget {
//   final String mId;
//   const MasteryExplenation({super.key, required this.mId});

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return LessonSectionLayout(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   AssetManager.result,
//                   width: MediaQuery.of(context).size.width < 950 ? 100 : 150,
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   "Final Mastery Assessment Page",
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize:
//                             MediaQuery.of(context).size.width < 950 ? 15 : 38,
//                       ),
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   "Course 1",
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   "Total Score: 50%",
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize:
//                             MediaQuery.of(context).size.width < 950 ? 15 : 20,
//                       ),
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'Result: ',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: MediaQuery.of(context).size.width < 950
//                                   ? 15
//                                   : 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'Pass',
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: MediaQuery.of(context).size.width < 950
//                                   ? 15
//                                   : 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     const Icon(Icons.info_outline)
//                   ],
//                 ),
//                 const SizedBox(height: 35),
//                 Wrap(
//                   alignment: WrapAlignment.spaceBetween,
//                   spacing: 15,
//                   runSpacing: 15,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(size.width / 5, 50),
//                       ),
//                       onPressed: () {
//                         GoRouter.of(context).push('/lesson/mastery/$mId');
//                       },
//                       child: Text(
//                         "RETAKE",
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(size.width / 5, 50),
//                       ),
//                       onPressed: () {
//                         GoRouter.of(context)
//                             .push('/lesson/mastery-assesment_summery');
//                       },
//                       child: Text(
//                         "REVIEW ANSWER",
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(size.width / 5, 50),
//                       ),
//                       onPressed: () {
//                         GoRouter.of(context).push('/evaluation-survey');
//                       },
//                       child: Text(
//                         "VIEW CERTIFICATE",
//                         style: size.width < 550
//                             ? Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(fontWeight: FontWeight.bold)
//                             : Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.10),
//                   child: TextFormField(
//                     maxLines: 10,
//                     decoration: InputDecoration(
//                       hintText: 'Feedback here',
//                       fillColor: Colors.grey[200],
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderSide: const BorderSide(color: borderColor),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ConstrainedBox(
//                   constraints:
//                       const BoxConstraints(minWidth: 200, maxWidth: 400),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       GoRouter.of(context)
//                           .push('/lesson/mastery-assesment_summery');
//                     },
//                     child: Text(
//                       "SEND",
//                       style: size.width < 550
//                           ? Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(fontWeight: FontWeight.bold)
//                           : Theme.of(context)
//                               .textTheme
//                               .bodyLarge!
//                               .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
