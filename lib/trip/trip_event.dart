import 'dart:io';
import 'package:meta/meta.dart';

@immutable
abstract class TripEvent {}

class AddTripButtonPressed extends TripEvent {
  final int days;
  final String address;
  final String placeId;
  final double rating;
  final String description;
  final File images;

  AddTripButtonPressed(
      {this.address,
      this.days,
      this.placeId,
      this.rating,
      this.description,
      this.images});
}
