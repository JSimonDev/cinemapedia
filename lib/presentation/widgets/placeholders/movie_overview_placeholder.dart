import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieOverviewPlaceholder extends StatelessWidget {
  final Size size;
  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
  );

  MovieOverviewPlaceholder({
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          Container(
            decoration: boxDecoration,
            height: size.height * 0.02,
            width: size.width,
          ),
          const SizedBox(height: 5),
          Container(
            decoration: boxDecoration,
            height: size.height * 0.02,
            width: size.width * 0.85,
          ),
          const SizedBox(height: 5),
          Container(
            decoration: boxDecoration,
            height: size.height * 0.02,
            width: size.width,
          ),
          const SizedBox(height: 5),
          Container(
            decoration: boxDecoration,
            height: size.height * 0.02,
            width: size.width * 0.85,
          ),
        ],
      ),
    );
  }
}
