import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieOriginalTitlePlaceholder extends StatelessWidget {
  final Size size;
  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
  );

  MovieOriginalTitlePlaceholder({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        decoration: boxDecoration,
        height: size.height * 0.015,
        width: size.width * 0.45,
      ),
    );
  }
}
