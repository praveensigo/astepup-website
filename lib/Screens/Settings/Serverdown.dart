import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';
import 'package:astepup_website/Resource/Strings.dart';

import '../Widgets/appbar.dart';

class Serverdown extends StatelessWidget {
  const Serverdown({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageSize =
        screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.7;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                AssetManager.serverdown,
                width: imageSize,
                height: imageSize,
              ),
              Text(
                Strings.serverdown,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(Strings.serverdownmessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!),
            ],
          ),
        ),
      ),
    );
  }
}
