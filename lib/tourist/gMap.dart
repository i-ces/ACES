import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/tourist/googleService.dart';
import 'package:ghumnajaam/tourist/placeDetail.dart';
import 'package:http/http.dart' as http;
import 'package:ghumnajaam/tourist/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GMap extends StatefulWidget {
  final Position userLocation;
  final String type;
  final List<double> distance;
  GMap(this.userLocation, this.type, this.distance);
  @override
  State<StatefulWidget> createState() {
    return _GMap();
  }
}

class _GMap extends State<GMap> {
  Set<Marker> _marker = {};
  GoogleMapController _controller;
  List<Place> _places;
  final Set<Polyline> _polyLines = {};
  LatLng _myPlace;
  CameraPosition cameraPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Geolocator geolocator;
  @override
  void initState() {
    super.initState();
    _myPlace =
        LatLng(widget.userLocation.latitude, widget.userLocation.longitude);
    cameraPosition = CameraPosition(
        target:
            LatLng(widget.userLocation.latitude, widget.userLocation.longitude),
        zoom: 14);
    getNearbyPlaces().then((data) {
      this.setState(() {
        _places = data;
        data.forEach((f) {
          getdistance(f.latLng['lat'], f.latLng['lng']).then((onValue) {
            double val = double.parse((onValue / 1000).toStringAsFixed(1));
            widget.distance.add(val);
          });
        });
        _marker.add(
          Marker(
            markerId: MarkerId('you'),
            position: LatLng(_myPlace.latitude, _myPlace.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: "You are here",
            ),
          ),
        );
      });
    });
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      _controller = controller;
    });

    _places.forEach((f) => this.setState(() {
          _marker.add(
            Marker(
                markerId: MarkerId(f.name + f.latLng.toString()),
                icon: (f.category == "restaurant")
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue)
                    : (f.category == "hospital")
                        ? BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueMagenta)
                        : BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueYellow),
                position: LatLng(f.latLng['lat'], f.latLng['lng']),

                // infoWindow: InfoWindow(title: f.name, snippet: f.category),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaceDetailWidget(f.placeId)));
                }),
          );
        }));
  }

  Widget _mapView() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      markers: _marker,
    );
  }

  void zoomInMarker(Place client) {
    _polyLines.clear();
    Position dest = Position(
        latitude: client.latLng['lat'], longitude: client.latLng['lng']);
    sendRequest(dest);
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(client.latLng['lat'], client.latLng['lng']),
      zoom: 17.0,
    )));
  }

  Future<double> getdistance(double lat, double lng) async {
    final double dis = await Geolocator().distanceBetween(
        widget.userLocation.latitude, widget.userLocation.longitude, lat, lng);

    print(dis);
    return dis;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNearbyPlaces(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container(
                  color: Color.fromRGBO(63, 169, 245, 1),
                )
              : Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.39,
                        child: _mapView()),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          color: Color.fromRGBO(63, 169, 245, 1),
                          child: ListView.builder(
                              dragStartBehavior: DragStartBehavior.down,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(left: 10.0),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: new ListTile(
                                      title: new Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data[index].rating
                                              .toString()),
                                          RatingBarIndicator(
                                            rating: snapshot.data[index].rating,
                                            itemCount: 5,
                                            itemSize: 18.0,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            unratedColor:
                                                Colors.amber.withAlpha(50),
                                          ),
                                        ],
                                      ),
                                      trailing: (widget.distance[index] == null)
                                          ? Icon(Icons.directions_car)
                                          : Text(widget.distance[index]
                                                  .toString() +
                                              " km"),
                                      onTap: () {
                                        zoomInMarker(snapshot.data[index]);
                                      }),
                                );
                              })),
                    )
                  ],
                );
        });
  }

  Future<List<Place>> getNearbyPlaces() async {
    http.Response response = await http.get(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.userLocation.latitude},${widget.userLocation.longitude}&radius=2500&type=${widget.type}&key=AIzaSyCqOpyZcoDGRaOk10J46AVLfBHdWXVdn0g",
        headers: {"Accept": "application/json"});

    List data = json.decode(response.body)["results"];
    List<Place> places = [];
    double d = 0.0;
    data.forEach((f) {
      bool contain = (f.containsKey('rating'));
      if (contain == true) {
        d = (f['rating'] + 0.0);
      } else {
        d = 0.0;
      }
      places.add(Place(
          category: f['types'][0],
          id: f['id'],
          latLng: f['geometry']['location'],
          name: f['name'],
          rating: d,
          placeId: f['place_id']));
    });

    return places;
  }

  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(_myPlace.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Color.fromRGBO(63, 169, 245, 1)));
    });
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void sendRequest(Position intendedLocation) async {
    double latitude = intendedLocation.latitude;
    double longitude = intendedLocation.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination);
    String route =
        await _googleMapsServices.getRouteCoordinates(_myPlace, destination);
    createRoute(route);
  }

  void _addMarker(LatLng location) {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId("myfinalpositionroute"),
          position: location,
          infoWindow: InfoWindow(title: "Go here"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }
}
