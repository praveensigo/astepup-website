// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// import 'package:astepup_website/Controller/QuizController.dart';
// import 'package:astepup_website/Resource/colors.dart';
// import 'package:astepup_website/Screens/Widgets/LessonSections.dart';

// class ResultReviewwidget extends StatefulWidget {
//   final String nextroute;
//   final String retakeroute;

//   final String title;
//   final String totalPercentage;
//   final List<ResultReviewQuestion> answersList;
//   final Function()? feedbackCallBack;
//   final Function()? retakeFunctionCallback;
//   final Function()? nextFunctionCallback;

//   const ResultReviewwidget({
//     super.key,
//     required this.title,
//     required this.totalPercentage,
//     required this.answersList,
//     this.feedbackCallBack,
//     this.retakeFunctionCallback,
//     this.nextFunctionCallback,
//     required this.nextroute,
//     required this.retakeroute,
//   });

//   @override
//   State<ResultReviewwidget> createState() => _ReviewAnswerWidgetState();
// }

// class _ReviewAnswerWidgetState extends State<ResultReviewwidget> {
//   @override
//   Widget build(BuildContext context) {
//     print("main route${widget.nextroute}");
//     var size = MediaQuery.of(context).size;
//     return ResponsiveBuilder(builder: (context, sizeInfo) {
//       return LessonSectionLayout(
//           body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: sizeInfo.isDesktop ? 45 : 25,
//               vertical: sizeInfo.isDesktop ? 15 : 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.title,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                         fontSize:
//                             MediaQuery.of(context).size.width < 950 ? 10 : 20),
//                   ),
//                   OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         vertical: MediaQuery.of(context).size.width < 950
//                             ? 5
//                             : 20, // Adjust the multiplier as needed
//                         horizontal: MediaQuery.of(context).size.width < 950
//                             ? 5
//                             : 20, // Adjust the multiplier as needed
//                       ),
//                     ),
//                     child: Text('FEEDBACK',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                             fontSize: MediaQuery.of(context).size.width < 950
//                                 ? 10
//                                 : 20)),
//                     onPressed: () => feedbackDialog(context),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 "Total Score: ${widget.totalPercentage}",
//                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize:
//                         MediaQuery.of(context).size.width < 950 ? 10 : 20),
//               ),
//               const SizedBox(height: 25),
//               ListView.separated(
//                   separatorBuilder: (_, __) => const SizedBox(height: 15),
//                   shrinkWrap: true,
//                   itemCount: widget.answersList.length,
//                   itemBuilder: (_, i) {
//                     return QuestionWidgetItem(
//                       questionIndex: i + 1,
//                       reviewQuestion: widget.answersList[i],
//                       explanationRoute: widget.nextroute,
//                     );
//                   }),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           // maximumSize: Size(400, 50),
//                           minimumSize: Size(size.width / 5, 50)),
//                       onPressed: () {
//                         GoRouter.of(context).push(widget.retakeroute);
//                       },
//                       child: Text(
//                         "RETAKE",
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .copyWith(fontWeight: FontWeight.bold),
//                       )),
//                   int.parse(Get.find<QuizController>().quizPercetage.isEmpty
//                               ? "50"
//                               : Get.find<QuizController>().quizPercetage) <
//                           50
//                       ? const SizedBox()
//                       : ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               // maximumSize: Size(400, 50),
//                               minimumSize: Size(size.width / 5, 50)),
//                           onPressed: () {
//                             GoRouter.of(context)
//                                 .push('/lesson/mastery-Summery');
//                           },
//                           child: Text(
//                             "NEXT",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                           ))
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ));
//     });
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
//                         onPressed: widget.feedbackCallBack ??
//                             () {
//                               Navigator.pop(context);
//                             },
//                         child: const Text("Send")),
//                   )
//                 ],
//               ),
//             ),
//           ));
//         });
//   }
// }

// class ResultReviewQuestion {
//   final String question;
//   final String answers;
//   final bool isCorrect;
//   ResultReviewQuestion({
//     required this.question,
//     required this.answers,
//     required this.isCorrect,
//   });

//   ResultReviewQuestion copyWith({
//     String? question,
//     String? answers,
//     bool? isCorrect,
//   }) {
//     return ResultReviewQuestion(
//       question: question ?? this.question,
//       answers: answers ?? this.answers,
//       isCorrect: isCorrect ?? this.isCorrect,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'question': question,
//       'answers': answers,
//       'isCorrect': isCorrect,
//     };
//   }

//   factory ResultReviewQuestion.fromMap(Map<String, dynamic> map) {
//     return ResultReviewQuestion(
//       question: map['question'] ?? '',
//       answers: map['answers'] ?? '',
//       isCorrect: map['isCorrect'] ?? false,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ResultReviewQuestion.fromJson(String source) =>
//       ResultReviewQuestion.fromMap(json.decode(source));

//   @override
//   String toString() =>
//       'ResultReviewQuestion(question: $question, answers: $answers, isCorrect: $isCorrect)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is ResultReviewQuestion &&
//         other.question == question &&
//         other.answers == answers &&
//         other.isCorrect == isCorrect;
//   }

//   @override
//   int get hashCode => question.hashCode ^ answers.hashCode ^ isCorrect.hashCode;
// }

// class QuestionWidgetItem extends StatelessWidget {
//   final String explanationRoute;
//   final int questionIndex;
//   final ResultReviewQuestion reviewQuestion;
//   const QuestionWidgetItem({
//     super.key,
//     required this.questionIndex,
//     required this.reviewQuestion,
//     required this.explanationRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "$questionIndex. ",
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               flex: 2,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       reviewQuestion.question,
//                       maxLines: 5,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   // GestureDetector(
//                   //     onTap: () {
//                   //       GoRouter.of(context).push('${explanationRoute}');
//                   //       print("route${explanationRoute}");
//                   //     },
//                   //     child: SvgPicture.asset(CustomIcons.search,
//                   //         width: MediaQuery.of(context).size.width < 950
//                   //             ? 15
//                   //             : 25)),
//                 ],
//               ),
//             )
//           ],
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             reviewQuestion.isCorrect
//                 ? Icon(
//                     Icons.check_circle,
//                     color: green,
//                     size: MediaQuery.of(context).size.width < 950 ? 10 : 20,
//                   )
//                 : Icon(
//                     Icons.cancel,
//                     color: red,
//                     size: MediaQuery.of(context).size.width < 950 ? 10 : 20,
//                   ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Text(reviewQuestion.answers,
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                       fontSize:
//                           MediaQuery.of(context).size.width < 950 ? 10 : 20)),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }
