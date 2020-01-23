import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/trek_details/googleService.dart';
// import 'package:ghumnajaam/tourist/placeDetail.dart';
import 'package:ghumnajaam/trek_details/trek.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrekDetail extends StatefulWidget {
  final Trek trek;
  TrekDetail(this.trek);
  @override
  TrekDetailState createState() {
    return new TrekDetailState();
  }
}

class TrekDetailState extends State<TrekDetail> {
  PageController _pagecontroller =
      new PageController(initialPage: 0, viewportFraction: 1.0);
  Set<Marker> _marker = {};
  GoogleMapController _controller;
  final Set<Polyline> _polyLines = {};

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  LatLng _myPlace;
  @override
  void initState() {
    super.initState();
    setState(() {
      _myPlace = LatLng(double.parse(widget.trek.days[0].lat),
          double.parse(widget.trek.days[0].lat));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      _controller = controller;
    });

    widget.trek.days.forEach((f) {
      Position dest = Position(
          latitude: double.parse(f.lat), longitude: double.parse(f.lng));
      sendRequest(dest);
      this.setState(() {
        _myPlace = LatLng(double.parse(f.lat), double.parse(f.lng));

        _marker.add(
          Marker(
            markerId: MarkerId(f.lng.toString() + f.day + f.lat.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            position: LatLng(double.parse(f.lat), double.parse(f.lng)),
            infoWindow: InfoWindow(title: "Day " + f.day, snippet: f.name),
          ),
        );
      });
    });
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

    return lList;
  }

  void sendRequest(Position intendedLocation) async {
    double latitude = intendedLocation.latitude;
    double longitude = intendedLocation.longitude;
    LatLng destination = LatLng(latitude, longitude);

    String route =
        await _googleMapsServices.getRouteCoordinates(_myPlace, destination);
    createRoute(route);
  }

  Widget _mapView() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80), topRight: Radius.circular(80)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              heightFactor: 0.3,
              widthFactor: 2.5,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(27.6952226, 85.3565402), zoom: 10),
                onMapCreated: onMapCreated,
                myLocationEnabled: true,
                markers: _marker,
                polylines: _polyLines,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget information() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.only(
        top: 40,
      ),
      child: ListView(
        children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Text("Information",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          ListTile(
            title: Text(
              "${widget.trek.trek_name}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Name"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.destination}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Destination"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.total_duration}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Total Days"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.best_Time}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Best Time"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.max_elevation}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Max Altitude"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.est_budget}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Estimated Budget"),
          ),
          ListTile(
            title: Text(
              "${widget.trek.trip_grade}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Difficulty"),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           PlaceDetailWidget(widget.trek.placeId)),
                  // ),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(63, 169, 245, 1)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "OTHER DETAIL",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(63, 169, 245, 1)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget days() {
    return Container(
        padding: EdgeInsets.only(
          top: 40,
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView(children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Text("Days Information",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              itemCount: widget.trek.days.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Text("${widget.trek.days[index].day}")),
                    title: Text("${widget.trek.days[index].name}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          height: 54.4,
          items: <Widget>[
            Icon(Icons.info, size: 30),
            Icon(Icons.date_range, size: 30),
            Icon(Icons.map, size: 30),
          ],
          animationCurve: Curves.bounceOut,
          animationDuration: Duration(milliseconds: 1000),
          onTap: (index) {
            switch (index) {
              case 0:
                _pagecontroller.animateToPage(
                  0,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.bounceOut,
                );
                break;
              case 1:
                _pagecontroller.animateToPage(
                  1,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.bounceOut,
                );
                break;
              case 2:
                _pagecontroller.animateToPage(
                  2,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.bounceOut,
                );
                break;
              default:
            }
          },
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(widget.trek.image))),
              padding: EdgeInsets.all(50),
            ),
            Padding(
              padding: EdgeInsets.only(top: 150),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80)),
                  color: Colors.white,
                ),
                child: PageView(
                  controller: _pagecontroller,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[information(), days(), _mapView()],
                ),
              ),
            )
          ],
        ));
  }
}
