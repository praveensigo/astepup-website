import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

class LessonVideoLoader extends StatelessWidget {
  const LessonVideoLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        child: ResponsiveBuilder(builder: (context, sizeInfo) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 3.0,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 15,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 15,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  sizeInfo.isDesktop
                      ? Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: List.generate(
                            3,
                            (index) => Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 25),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 10,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
