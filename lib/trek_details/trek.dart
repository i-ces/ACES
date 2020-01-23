class Trek {
  final String trek_name;
  final String destination;
  final String trip_grade;
  final String max_elevation;
  final String total_duration;
  final String best_Time;
  final String est_budget;
  final String image;
  final String placeId;
  final List<Day> days;

  Trek(
      {this.trek_name,
      this.best_Time,
      this.destination,
      this.est_budget,
      this.max_elevation,
      this.total_duration,
      this.trip_grade,
      this.image,
      this.placeId,
      this.days});

  factory Trek.fromJson(Map<String, dynamic> json) {
    var list = json['days'] as List;
    print(list);
    List<Day> daysList = list.map((i) => Day.fromJson(i)).toList();

    return new Trek(
        trek_name: json['name'],
        best_Time: json['best_Time'],
        destination: json['destination'],
        est_budget: json['est_budget'],
        max_elevation: json['max_elevation'],
        total_duration: json['total_duration'],
        trip_grade: json['trip_grade'],
        image: json['image'],
        placeId: json['placeId'],
        days: daysList);
  }
}

class Day {
  final String day;
  final String name;
  final String lat;
  final String lng;
  Day({this.name, this.day, this.lat, this.lng});
  factory Day.fromJson(Map<String, dynamic> parsedJson) {
    return Day(
        day: parsedJson['day'],
        name: parsedJson['name'],
        lat: parsedJson['lat'],
        lng: parsedJson['lng']);
  }
}
