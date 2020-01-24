import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/profile/other_profile.dart';
import 'package:ghumnajaam/tourist/googleService.dart';
import 'package:ghumnajaam/tourist/searchGuideList.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GuideMap extends StatefulWidget {
  final Position userLocation;
  GuideMap(this.userLocation);
  @override
  State<StatefulWidget> createState() {
    return _GuideMap();
  }
}

class _GuideMap extends State<GuideMap> {
  Set<Marker> _marker = {};
  GoogleMapController _controller;
  List<AccountModel> _places;
  LatLng _myPlace;
  CameraPosition cameraPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  final Set<Polyline> _polyLines = {};
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
    fetchSelectedGuides(
            widget.userLocation.latitude, widget.userLocation.longitude)
        .then((data) {
      this.setState(() {
        _places = data;

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
                markerId: MarkerId("${f.lattitude.toString()}${f.firstName}"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: LatLng(f.lattitude, f.longitude),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherProfilePage(model: f)));
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
      onTap: _handleTapMarker,
      polylines: _polyLines,
    );
  }

  void _handleTapMarker(LatLng point) {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Tap to view guides',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchGuideListWidget(point)),
              )));
    });
  }

  void zoomInMarker(AccountModel client) {
    _polyLines.clear();
    Position dest =
        Position(latitude: client.lattitude, longitude: client.longitude);
    sendRequest(dest, client);
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(client.lattitude, client.longitude),
      zoom: 17.0,
    )));
  }

  Future<double> getdistance(double lat, double lng) async {
    final double dis = await Geolocator().distanceBetween(
        widget.userLocation.latitude, widget.userLocation.longitude, lat, lng);
    return dis;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AccountRepository().fetchSelectedGuides(
            widget.userLocation.latitude, widget.userLocation.longitude),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(
                    child: RefreshProgressIndicator(),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.39,
                        child: _mapView()),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          color: Colors.redAccent,
                          child: ListView.builder(
                              dragStartBehavior: DragStartBehavior.down,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(left: 10.0),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: new ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data[index].profilepic),
                                      ),
                                      title: new Text(
                                        snapshot.data[index].firstName +
                                            " " +
                                            snapshot.data[index].lastName,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          FlutterRatingBarIndicator(
                                            rating: snapshot.data[index].rating,
                                            itemCount: 5,
                                            itemSize: 18.0,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            emptyColor:
                                                Colors.amber.withAlpha(50),
                                          ),
                                        ],
                                      ),
                                      onTap: () =>
                                          zoomInMarker(snapshot.data[index])),
                                );
                              })),
                    )
                  ],
                );
        });
  }

  Future<List<AccountModel>> fetchSelectedGuides(double lat, double lng) async {
    List<AccountModel> _accountList = [];
    await http.get(
        "https://4fd81aa6.ngrok.io/api/accounts/guides/?latitude=$lat&longitude=$lng",
        headers: {
          'Content-Type': 'application/json',
        }).then((http.Response response) {
      var jsonData1 = json.decode(response.body);

      List<AccountModel> accounts = [];
      jsonData1.forEach((jsonData) {
        AccountModel account = AccountModel(
            id: jsonData['user']['id'],
            email: jsonData['user']['email'],
            firstName: jsonData['user']['first_name'],
            lastName: jsonData['user']['last_name'],
            username: jsonData['user']['username'],
            profilepic: jsonData['profile_pic'],
            lattitude: double.parse(jsonData['latitude']),
            longitude: double.parse(jsonData['longitude']),
            phone: jsonData['phone_number'],
            bio: jsonData['bio'],
            price: jsonData['pricing'].toString(),
            rating: (jsonData['rating'] + 0.0));
        accounts.add(account);
      });
      _accountList = accounts;
    });
    return _accountList;
  }

  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(_myPlace.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.redAccent));
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

  void sendRequest(Position intendedLocation, AccountModel client) async {
    double latitude = intendedLocation.latitude;
    double longitude = intendedLocation.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, client);
    String route =
        await _googleMapsServices.getRouteCoordinates(_myPlace, destination);
    createRoute(route);
  }

  void _addMarker(LatLng location, AccountModel client) {
    setState(() {
      _marker.add(Marker(
        markerId: MarkerId("myfinalpositionroute"),
        position: location,
        infoWindow: InfoWindow(title: "Go here"),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtherProfilePage(model: client)));
        },
      ));
    });
  }
}
