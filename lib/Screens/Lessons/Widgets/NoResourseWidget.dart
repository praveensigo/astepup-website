import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';

class NoResourseWidget extends StatelessWidget {
  const NoResourseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AssetManager.documentInfo,
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          "There is no resource available for this lesson\n at the moment to show you.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
