import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/tourist/guideLists.dart';
import 'package:ghumnajaam/tourist/guideMap.dart';
import 'package:google_maps_webservice/places.dart';

class NearbyGuide extends StatefulWidget {
  final Position userLocation;

  const NearbyGuide(this.userLocation);

  @override
  State<StatefulWidget> createState() {
    return _NearbyGuide();
  }
}

// ignore: must_be_immutable
class _NearbyGuide extends State<NearbyGuide> {
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
          "Nearby Guides",
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
        backgroundColor: Color.fromRGBO(63, 169, 245, 1),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new NeverScrollableScrollPhysics(),
            children: <Widget>[
              GuideMap(_myPosition),
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
          apiKey: 'AIzaSyCqOpyZcoDGRaOk10J46AVLfBHdWXVdn0g',
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
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuideListWidget(placeId)),
      );
    }
  }
}
