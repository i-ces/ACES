import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/inputs/location_data.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  Function setLocation;
  LocationInput(this.setLocation);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  Geolocator geolocator = Geolocator();

  Position userLocation;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void getStaticMap(double lat, double lng) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': 'jdsbvjkdbvkjbdvjkbvjkbcvjkbsKJdbvkjbvjb'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];

    final coords = decodedResponse['results'][0]['geometry']['location'];
    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng']);
    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = formattedAddress;
    });
  }

  void _updateLocation() {
    if (_addressInputFocusNode.hasFocus) {
      getStaticMap(userLocation.latitude, userLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Tap to get your location',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a valid location';
              }
            },
          ),
        ),
      ],
    );
  }
}
