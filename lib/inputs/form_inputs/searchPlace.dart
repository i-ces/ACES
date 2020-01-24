import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ghumnajaam/inputs/location_data.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';

class SearchLocationInput extends StatefulWidget {
  final Function setLocation;

  SearchLocationInput({this.setLocation});

  @override
  State<StatefulWidget> createState() {
    return _SearchLocationInputState();
  }
}

class _SearchLocationInputState extends State<SearchLocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': '$address', 'key': 'AIzaSyBfecbv7_Q3gvbif7vhRs7VEmhwgkJxoWI'},
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];
    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng'],
        placeId: decodedResponse['results'][0]['place_id']);
    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = _locationData.address;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
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
              hintText: 'Search Place',
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
