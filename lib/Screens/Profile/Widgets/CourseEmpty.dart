import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';

class CourseEmptyState extends StatelessWidget {
  const CourseEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetManager.nocourse,
            width: 300,
            height: 300,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(Strings.profileCourseEmpty,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
