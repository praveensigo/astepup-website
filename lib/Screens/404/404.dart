import 'package:flutter/material.dart';
import 'package:astepup_website/Resource/AssetsManger.dart';

import '../Widgets/appbar.dart';

class ErrorScreen extends StatelessWidget {
  final String? method;
  final String? api;
  const ErrorScreen({super.key, this.method, this.api});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetManager.notfound),
                const SizedBox(height: 25),
                Text(
                  "404 Error",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                method != null || api != null
                    ? Text.rich(TextSpan(
                        text: "Api issue in ",
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                            TextSpan(
                                text: '$api, method:$method',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold))
                          ]))
                    : Text(
                        "Page not found.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
              ],
            ),
          ),
        ));
  }
}
