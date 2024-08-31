import 'package:flutter/material.dart';

class CourseDetailsLoaderWidget extends StatelessWidget {
  final bool sectionLoading;
  const CourseDetailsLoaderWidget({
    this.sectionLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 88.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            sectionLoading
                ? const SizedBox()
                : SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: 158.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 10.0,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            ListView.separated(
                itemCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, i) => const SizedBox(height: 16),
                itemBuilder: (_, i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    margin: const EdgeInsets.only(right: 15),
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
