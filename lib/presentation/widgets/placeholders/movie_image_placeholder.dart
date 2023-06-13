import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieImagePlaceholder extends StatelessWidget {
  final Size size;

  const MovieImagePlaceholder({
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
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            width: size.width,
            height: size.height * 0.7,
          ),
        ],
      ),
    );
  }
}
