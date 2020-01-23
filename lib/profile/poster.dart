import 'package:flutter/material.dart';

class Poster extends StatelessWidget {
  static const POSTER_RATIO = 0.6;

  Poster(
    this.posterUrl, {
    this.height = 90.0,
  });

  final String posterUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (posterUrl == null)
                ? AssetImage('assets/images/mountains.jpg')
                : NetworkImage(
                    posterUrl,
                  ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => Center(
                  child: Card(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Image.network(posterUrl, fit: BoxFit.cover),
                  ),
                ));
      },
    );
  }
}
