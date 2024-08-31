import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';

class NoCourse extends StatelessWidget {
  const NoCourse({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageSize =
        screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.7;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 75, top: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome, john jacob",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Image.asset(
              AssetManager.nocourse,
              width: imageSize,
              height: imageSize,
            ),
            Text(
              Strings.nocourse,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(Strings.nocourseavailable,
                style: Theme.of(context).textTheme.bodyMedium!),
          ],
        ),
      ),
    );
  }
}
