class TripModel {
  final int id;
  final String name;
  final String time;
  final int days;
  final String address;
  final String placeId;
  final double rating;
  final String details;
  final String urls;
  final String profilePic;
  final String review;
  final String price;

  TripModel(
      {this.address,
      this.price,
      this.id,
      this.urls,
      this.details,
      this.days,
      this.placeId,
      this.rating,
      this.name,
      this.time,
      this.profilePic,
      this.review});
}
