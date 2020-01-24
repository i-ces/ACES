import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/tourist/gMap.dart';
import 'package:ghumnajaam/tourist/placeDetail.dart';
import 'package:google_maps_webservice/places.dart';

class NearbyPlaces extends StatefulWidget {
  final Position userLocation;

  const NearbyPlaces(this.userLocation);

  @override
  State<StatefulWidget> createState() {
    return _NearbyPlaces();
  }
}

// ignore: must_be_immutable
class _NearbyPlaces extends State<NearbyPlaces> {
  Position _myPosition;
  @override
  void initState() {
    _myPosition = widget.userLocation;

    super.initState();
  }

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);
  Geolocator geolocator;
  final _locationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<double> dist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Map",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _handlePressButton();
            },
          )
        ],
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.redAccent,
        height: 54.4,
        items: <Widget>[
          Icon(Icons.local_hotel, size: 30),
          Icon(Icons.local_hospital, size: 30),
          Icon(Icons.local_florist, size: 30),
        ],
        animationCurve: Curves.bounceOut,
        animationDuration: Duration(milliseconds: 1000),
        onTap: (index) {
          switch (index) {
            case 0:
              _controller.animateToPage(
                0,
                duration: Duration(milliseconds: 800),
                curve: Curves.bounceOut,
              );
              break;
            case 1:
              _controller.animateToPage(
                1,
                duration: Duration(milliseconds: 800),
                curve: Curves.bounceOut,
              );
              break;
            case 2:
              _controller.animateToPage(
                2,
                duration: Duration(milliseconds: 800),
                curve: Curves.bounceOut,
              );
              break;
            default:
          }
        },
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new NeverScrollableScrollPhysics(),
            children: <Widget>[
              GMap(_myPosition, "restaurant", dist),
              GMap(_myPosition, "hospital", dist),
              GMap(_myPosition, "attractions", dist),
            ],
          )),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = widget.userLocation;
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: 'jdsbvjkdbvkjbdvjkbvjkbcvjkbsKJdbvkjbvjb',
          mode: Mode.overlay,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 400000);
      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    print(placeId);
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }
}
