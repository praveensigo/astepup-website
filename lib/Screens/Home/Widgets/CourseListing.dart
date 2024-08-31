import 'package:flutter/material.dart';
import 'package:astepup_website/Model/HomeModel.dart';

import 'CourseCard.dart';

class CourseListingWidget extends StatelessWidget {
  final List<Course> course;
  final String title;
  final int length;
  final Axis scrollDirection;
  final bool isCourseComplete;
  final ScrollPhysics? physics;
  const CourseListingWidget({
    super.key,
    required this.title,
    required this.length,
    this.scrollDirection = Axis.horizontal,
    this.isCourseComplete = false,
    this.physics,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return course.isEmpty
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: scrollDirection == Axis.vertical
                    ? null
                    : isCourseComplete
                        ? 380
                        : 350,
                child: ListView.separated(
                    clipBehavior: Clip.none,
                    separatorBuilder: (_, __) => SizedBox(
                          width: scrollDirection == Axis.vertical ? null : 20,
                          height: scrollDirection == Axis.vertical ? 20 : 0,
                        ),
                    shrinkWrap: true,
                    physics: physics,
                    scrollDirection: scrollDirection,
                    itemCount: length,
                    itemBuilder: (_, i) {
                      return CoursesCard(
                        isComplete: isCourseComplete,
                        course: course[i],
                      );
                    }),
              ),
            ],
          );
  }
}
