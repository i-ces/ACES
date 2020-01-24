import 'package:flutter/material.dart';

class Place {
  Place(
      {@required this.id,
      @required this.latLng,
      @required this.name,
      @required this.category,
      this.rating,
      this.placeId});
  final String id;
  final Map<String, dynamic> latLng;
  final String name;
  final String category;
  final double rating;
  final String placeId;
}
