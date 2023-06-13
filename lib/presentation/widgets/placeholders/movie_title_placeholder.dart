import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieTitlePlaceholder extends StatelessWidget {
  final Size size;
  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
  );

  MovieTitlePlaceholder({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Container(
            decoration: boxDecoration,
            height: size.height * 0.03,
            width: size.width,
          ),
        ],
      ),
    );
  }
}
