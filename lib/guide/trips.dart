import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';

class GuideTrip extends StatefulWidget {
  
  GuideTrip({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GuideTrip();
  }
}

class _GuideTrip extends State<GuideTrip> {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  final _ratingController = TextEditingController();
  final _daysController = TextEditingController();
  final _placeIdController = TextEditingController();
  final _locationController = TextEditingController();

  double _userRating = 0.0;
  

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
      print(userLocation.latitude);
    });
  }

  Future<Position> _getLocation() async {
    Position currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    print(currentLocation);
    return currentLocation;
  }

  Widget _daysField() {
    return TextFormField(
      controller: _daysController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Days of trip',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid name';
        }
      },
    );
  }

  Widget _rating() {
    return TextFormField(
      controller: _ratingController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter place rating and press rate',
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: MaterialButton(
          onPressed: () {
            setState(() {
              _userRating = double.parse(_ratingController.text ?? "0.0");
            });
          },
          child: Text("Rate"),
        ),
      ),
      validator: (String value) {
        if (value.isEmpty ||
            double.parse(value ?? "0.0") > 5 ||
            double.parse(value ?? "0.0") < 0) {
          return 'Please enter a valid rating';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tripCreate() {
      return ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: Center(
                child: Icon(
                  Icons.map,
                  color: Color.fromRGBO(63, 169, 245, 1),
                  size: 50.0,
                ),
              ),
            ),
            Form(
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: new Text(
                            "LOCATION",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(63, 169, 245, 1),
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Color.fromRGBO(63, 169, 245, 1),
                            width: 0.5,
                            style: BorderStyle.solid),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Container(),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: new Text(
                            "No of days of Trip",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(63, 169, 245, 1),
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(63, 169, 245, 1),
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: _daysField()),
                  SizedBox(
                    height: 20,
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: new Text(
                            "RATE THE PLACE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(63, 169, 245, 1),
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(63, 169, 245, 1),
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: _rating()),
                  SizedBox(
                    height: 24.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Row(children: <Widget>[
                      new Expanded(
                        child: FlatButton(
                          onPressed:() {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text("View your trips"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Go"),
                                                onPressed: () {}
                                              )
                                            ],
                                          ));
                                },
                              
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          splashColor: Color.fromRGBO(63, 169, 245, 1),
                          color: Color.fromRGBO(63, 169, 245, 1),
                          child: new Row(
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Add My Trip",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            )
          ]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("My Trip"),
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {}
            )
          ],
        ),
        body: Container(
                height: MediaQuery.of(context).size.height,
                color: Color.fromRGBO(63, 169, 245, 1),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  children: <Widget>[
                    Center(
                      child: Text("Add place to my trip"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Card(
                        child: tripCreate(),
                      ),
                    )
                  ],
                ),
              ),
    );
            
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final len = size.width;
    path.lineTo(0, 1 / 4 * len);
    path.lineTo(1 / 4 * len, 0);
    path.lineTo(3 / 4 * len, 0);
    path.lineTo(len, 1 / 4 * len);
    path.lineTo(1 / 2 * len, len);
    path.lineTo(0, 1 / 4 * len);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
