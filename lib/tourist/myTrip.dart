import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/inputs/form_inputs/searchPlace.dart';
import 'package:ghumnajaam/inputs/location_data.dart';
import 'package:ghumnajaam/profile/feeds.dart';
import 'package:ghumnajaam/tourist/nearbyPlaces.dart';
import 'package:ghumnajaam/trip/index.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyTrip extends StatefulWidget {
  final TripBloc tripBloc;
  MyTrip({
    Key key,
    @required this.tripBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyTrip();
  }
}

class _MyTrip extends State<MyTrip> {
  Geolocator geolocator = Geolocator();
  Position userLocation;
  final _ratingController = TextEditingController();
  final _daysController = TextEditingController();
  final _placeIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File images;
  String _error;
  double _userRating = 0.0;
  TripBloc get _tripBloc => widget.tripBloc;
  Future<void> loadAssets() async {
    setState(() {
      images = null;
    });

    File resultList;
    String error;

    try {
      resultList = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
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

  Widget _descriptionField() {
    return TextFormField(
      controller: _descriptionController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Details of trip',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (String value) {
        if (value.isEmpty || value.length <= 10) {
          return 'Please enter a valid detail';
        }
      },
    );
  }

  Widget _rating() {
    return RatingBar(
      initialRating: 0.0,
      allowHalfRating: true,
      ignoreGestures: false,
      tapOnlyMode: false,
      itemCount: 5,
      itemSize: 30.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      onRatingUpdate: (rating) {
        print(rating);
        setState(() {
          _userRating = rating;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tripCreate(TripState state) {
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
              key: _formKey,
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
                    child: SearchLocationInput(
                      setLocation: _setLocation,
                    ),
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
                            "IMAGES OF THE PLACE",
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
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        color: Color.fromRGBO(63, 169, 245, 1),
                        onPressed: () {
                          loadAssets();
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: images == null
                        ? Text('No image selected.')
                        : Image.file(
                            images,
                            height: 200,
                          ),
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
                            "Description",
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
                      child: _descriptionField()),
                  SizedBox(
                    height: 24,
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
                  SizedBox(
                    height: 24.0,
                  ),
                  new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
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
                          onPressed: state is! TripLoading
                              ? () {
                                  _onSignUpButtonPressed();
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text("View your trips"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Go"),
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TripPage())),
                                              )
                                            ],
                                          ));
                                }
                              : null,
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
              onPressed: () => (userLocation == null)
                  ? null
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NearbyPlaces(userLocation))),
            )
          ],
        ),
        body: BlocBuilder<TripBloc, TripState>(
            bloc: _tripBloc,
            builder: (
              BuildContext context,
              TripState state,
            ) {
              if (state is ErrorTripState) {
                _onWidgetDidBuild(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('An Error Occurred!'),
                        content: Text("${state.errorMessage}"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                });
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                color: Color.fromRGBO(63, 169, 245, 1),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Add place to my trip",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Card(
                        child: tripCreate(state),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _setLocation(LocationData locData) {
    _locationController.text = locData.address;
    _placeIdController.text = locData.placeId;
  }

  _onSignUpButtonPressed() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _tripBloc.add(AddTripButtonPressed(
        days: int.parse(_daysController.text),
        address: _locationController.text,
        placeId: _placeIdController.text,
        rating: _userRating,
        images: images,
        description: _descriptionController.text));
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 0.5, size.height * 0.15);
    path.lineTo(size.width * 0.35, size.height * 0.4);
    path.lineTo(0.0, size.height * 0.4);
    path.lineTo(size.width * 0.25, size.height * 0.55);
    path.lineTo(size.width * 0.1, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width * 0.9, size.height * 0.8);
    path.lineTo(size.width * 0.75, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width * 0.65, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.15);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
