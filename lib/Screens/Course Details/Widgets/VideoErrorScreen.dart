import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';

class VideoErrorScreen extends StatelessWidget {
  const VideoErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetManager.serverdown),
          Text(
            "Sorry",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            "There are currently some problems loading the video. Kindly give it another go.",
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
