import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class RatingAndDate extends StatelessWidget {
  final Movie movie;
  final bool? ignoreGestures;
  final bool? allowHalfRating;
  final Color? numberColor;
  final Color? iconColor;
  final double? numberSize;
  final double? iconSize;
  final double? minRating;
  final double? maxRating;
  final IconData? icon;
  final String? noDateText;

  const RatingAndDate({
    super.key,
    required this.movie,
    this.ignoreGestures,
    this.allowHalfRating,
    this.numberColor,
    this.iconColor,
    this.numberSize,
    this.iconSize,
    this.minRating,
    this.maxRating,
    this.icon,
    this.noDateText,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* NUMBER
          Text(
            HumanFormats.number(movie.voteAverage, decimals: 1),
            style: TextStyle(
                fontSize: numberSize ?? 20,
                color: numberColor ?? Colors.yellow.shade800,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 4),

          //* STARS
          RatingBar.builder(
            ignoreGestures: ignoreGestures ?? true,
            itemSize: iconSize ?? 25,
            initialRating: movie.voteAverage / 2,
            minRating: minRating ?? 0,
            maxRating: maxRating ?? 10,
            allowHalfRating: allowHalfRating ?? true,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              icon ?? Icons.star_rounded,
              color: iconColor ?? Colors.yellow.shade800,
            ),
            onRatingUpdate: (rating) {},
          ),

          const Spacer(),

          //* DIVIDER
          const VerticalDivider(
            indent: 3,
            endIndent: 3,
            thickness: 1,
          ),

          //* DATE
          movie.releaseDate != ''
              ? Text(
                  movie.releaseDate,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                )
              : Text(
                  noDateText ?? 'Sin Fecha',
                  style: const TextStyle(fontWeight: FontWeight.w300),
                )
        ],
      ),
    );
  }
}
