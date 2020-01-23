class Bus {
  final String from;
  final String to;
  final String price;
  final String time;

  Bus({this.from, this.price, this.time, this.to});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
        from: json['from'],
        to: json['to'],
        price: json['price'],
        time: json['time']);
  }
}
