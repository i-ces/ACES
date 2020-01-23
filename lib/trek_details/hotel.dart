class Hotel{
  final String title;
  final String url;
  final String address;
  final String phone;
  final String price;

   Hotel({this.title, this.url, this.address, this.phone,this.price});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        title: json['title'],
        url: json['url'],
        address: json['address'],
        phone: json['phone'],
        price: json['price'],
        );
  }
}