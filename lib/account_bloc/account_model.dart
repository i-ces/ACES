class AccountModel {
  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String bio;
  final double lattitude;
  final double longitude;
  final String profilepic;
  final String phone;
  final String tourist;
  final String guide;
  final int reqId;
  final double rating;
  final String message;
  final String price;
  AccountModel(
      {this.reqId,
      this.message,
      this.rating,
      this.firstName,
      this.id,
      this.email,
      this.lastName,
      this.username,
      this.name,
      this.phone,
      this.bio,
      this.lattitude,
      this.longitude,
      this.profilepic,
      this.tourist,
      this.guide,
      this.price});
}
