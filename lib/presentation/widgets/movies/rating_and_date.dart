import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingAndDate extends StatelessWidget {
  final Movie movie;
  final double? numberSize;
  final Color? numberColor;
  final double? iconSize;
  final double? minRating;
  final double? maxRating;
  final bool? allowHalfRating;
  final IconData? icon;
  final Color? iconColor;
  final String? noDateText;

  const RatingAndDate({
    super.key,
    required this.movie,
    this.numberSize,
    this.numberColor,
    this.iconSize,
    this.minRating,
    this.maxRating,
    this.allowHalfRating,
    this.icon,
    this.iconColor,
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
            thickness: 2,
          ),

          //* DATE
          movie.releaseDate != null
              ? Text(
                  HumanFormats.date(movie.releaseDate!),
                )
              : Text(noDateText ?? 'Sin Fecha')
        ],
      ),
    );
  }
}
