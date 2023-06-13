import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieRatingPlaceholder extends StatelessWidget {
  final Size size;
  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
  );

  MovieRatingPlaceholder({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              decoration: boxDecoration,
              height: size.height * 0.02,
              width: size.width * 0.41,
            ),
            const Spacer(),
            Container(
              decoration: boxDecoration,
              height: size.height * 0.02,
              width: size.width * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
