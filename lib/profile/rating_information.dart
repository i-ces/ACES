import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingInformation extends StatelessWidget {
  RatingInformation(this.rating);
  final double rating;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption.copyWith(color: Colors.black45);

    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.title.copyWith(
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(63, 169, 245, 1),
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'Ratings',
          style: ratingCaptionStyle,
        ),
      ],
    );

    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RatingBarIndicator(
          rating: (rating + 0.0),
          itemCount: 5,
          itemSize: 18.0,
          unratedColor: Colors.grey,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: 1.0),
        starRating,
      ],
    );
  }
}
