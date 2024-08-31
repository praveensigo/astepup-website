import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

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
            Image.asset(
              AssetManager.notfound,
              width: imageSize,
              height: imageSize,
            ),
            Text(
              Strings.error,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(Strings.notfound,
                style: Theme.of(context).textTheme.bodyMedium!),
          ],
        ),
      ),
    );
  }
}
