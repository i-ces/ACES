import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/authentication/authentication_bloc.dart';
import 'package:ghumnajaam/profile/arc_banner_image.dart';
import 'package:ghumnajaam/profile/otherFeed.dart';
import 'package:ghumnajaam/profile/poster.dart';
import 'package:ghumnajaam/profile/rating_information.dart';
import 'package:ghumnajaam/profile/reviews.dart';
import 'package:ghumnajaam/profile/story_line.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class OtherProfilePage extends StatefulWidget {
  final AccountModel model;
  OtherProfilePage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OtherProfilePage();
  }
}

class _OtherProfilePage extends State<OtherProfilePage> {
  bool flag;
  double _userRating = 0.0;

  bool isLoading = false;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _reviewKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    getFlag().then((f) {
      setState(() {
        flag = f;
      });
    });
  }

  Future<bool> getFlag() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool flag1 = prefs.getBool('flag');
    print(flag1);
    return flag1;
  }

  Widget _rating() {
    return RatingBar(
      initialRating: widget.model.rating,
      allowHalfRating: true,
      ignoreGestures: false,
      tapOnlyMode: false,
      itemCount: 5,
      itemSize: 30.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      onRatingUpdate: (rating) {
        print(rating);
        setState(() {
          if (rating > 5) {
            _userRating = (5.0 + widget.model.rating) / 2;
          } else if (rating < 0) {
            _userRating = (0.0 + widget.model.rating) / 2;
          } else {
            _userRating = (rating + widget.model.rating) / 2;
          }
        });
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
          return 'Please enter a valid detail(Must be greater than 10 character)';
        }
      },
    );
  }

  Widget _reviewField() {
    return TextFormField(
      controller: _reviewController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Review ',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a review';
        }
      },
    );
  }

  Widget _buildFromTextField() {
    return DateTimeField(
      format: DateFormat('yyyy-MM-dd'),
      decoration: InputDecoration(
        labelText: 'From',
        hasFloatingPlaceholder: false,
      ),
      onSaved: (dt) {
        _fromController.text =
            "${dt.year.toString()}-${dt.month.toString()}-${dt.day.toString()}";
      },
      validator: (DateTime value) {
        if (value.toString().isEmpty) {
          return 'Please enter a valid date';
        }
      },
    );
  }

  Widget _buildToTextField() {
    return DateTimePickerFormField(
      inputType: InputType.date,
      format: DateFormat('yyyy-MM-dd'),
      editable: true,
      decoration: InputDecoration(
        labelText: 'To',
        hasFloatingPlaceholder: false,
      ),
      dateOnly: true,
      validator: (DateTime value) {
        if (value.toString().isEmpty) {
          return 'Please enter a valid date';
        }
      },
      onSaved: (dt) => setState(() => _toController.text =
          "${dt.year.toString()}-${dt.month.toString()}-${dt.day.toString()}"),
    );
  }

  Widget reviewForm() {
    return Center(
        child: Card(
            elevation: 4.0,
            margin: EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Form(
                  key: _reviewKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: new Text(
                                "RATE THE GUIDE",
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
                          padding:
                              const EdgeInsets.only(left: 0.0, right: 10.0),
                          child: _rating()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                "REVIEW",
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
                              left: 20.0, right: 20.0, top: 10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(63, 169, 245, 1),
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          padding:
                              const EdgeInsets.only(left: 0.0, right: 10.0),
                          child: _reviewField()),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text('Okay'),
                              onPressed: () async {
                                if (!_reviewKey.currentState.validate()) {
                                  return;
                                }
                                _reviewKey.currentState.save();
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final String token = prefs.getString('token');
                                String _headersKey = "Authorization";
                                String _headersValue = "Token " + token;
                                print(widget.model.id.toString());
                                Map<String, dynamic> authData = {
                                  'guide': widget.model.id,
                                  'review': _reviewController.text,
                                  "rating": _userRating
                                };
                                await http.get(
                                    "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/accounts/guides/rate/?guideid=${widget.model.id}&rating=$_userRating",
                                    headers: {
                                      _headersKey: _headersValue,
                                      'Content-Type': 'application/json'
                                    });
                                await http.post(
                                    "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/accounts/review/create/",
                                    body: json.encode(authData),
                                    headers: {
                                      _headersKey: _headersValue,
                                      'Content-Type': 'application/json'
                                    }).then((http.Response response) {
                                  print(response.body);
                                });

                                Navigator.of(context).pop();
                              },
                            )
                          ]),
                    ],
                  )),
              padding: EdgeInsets.only(top: 20),
            )));
  }

  Widget hireForm() {
    return Center(
      child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(20.0),
          child: Container(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              "MESSAGE TO GUIDE",
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
                            left: 20.0, right: 20.0, top: 10.0),
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
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              "FROM",
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
                            left: 20.0, right: 20.0, top: 10.0),
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
                        child: _buildFromTextField()),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              "UPTO DATE",
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
                            left: 20.0, right: 20.0, top: 10.0),
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
                        child: _buildToTextField()),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.only(right: 10.0),
                          color: Color.fromRGBO(63, 169, 245, 1),
                          child: Text(
                            'Okay',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final String token = prefs.getString('token');
                            String _headersKey = "Authorization";
                            String _headersValue = "Token " + token;
                            print(_headersValue);
                            final Map<String, dynamic> authData = {
                              "guide": widget.model.id,
                              "hiringdetail": ''' ${_descriptionController.text}
                                                 From:${_fromController.text}
                                                 To:${_toController.text} '''
                            };
                            print(widget.model.id);
                            http.Response response = await http.post(
                                "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/hire/request/",
                                body: json.encode(authData),
                                headers: {
                                  _headersKey: _headersValue,
                                  'Content-Type': 'application/json'
                                });
                            print(response.body);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                  ],
                )),
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.only(top: 20, right: 20.0),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCoverImage(Size screenSize) {
      return Container(
          width: screenSize.width,
          height: screenSize.height / 2.8,
          decoration: new BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover)));
    }

    Widget _buildProfileImage(Size screenSize) {
      return Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: screenSize.height / 4.6),
          InkWell(
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (widget.model.profilepic == null)
                      ? AssetImage('assets/images/logo.png')
                      : NetworkImage(
                          widget.model.profilepic,
                        ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(80.0),
                border: Border.all(
                  color: Colors.white,
                  width: 10.0,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => Center(
                        child: Card(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image.network(widget.model.profilepic,
                              fit: BoxFit.cover),
                        ),
                      ));
            },
          ),
        ],
      ));
    }

    Widget _buildFullName() {
      TextStyle _nameTextStyle = TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
      );

      return Text(
        widget.model.firstName + " " + widget.model.lastName,
        style: _nameTextStyle,
      );
    }

    Widget _buildStatus(BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          widget.model.email,
          style: TextStyle(
            fontFamily: 'Spectral',
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    Widget _buildStatItem(String count) {
      TextStyle _statCountTextStyle = TextStyle(
        color: Colors.white54,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count,
            style: _statCountTextStyle,
          ),
        ],
      );
    }

    Widget _buildStatContainer() {
      return (flag == false)
          ? Container(
              height: 60.0,
              margin: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildStatItem("Visit Nepal 2020"),
                ],
              ),
            )
          : Container(
              height: 60.0,
              margin: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildStatItem("Rating"),
                  RatingBarIndicator(
                    rating: (widget.model.rating + 0.0),
                    itemCount: 5,
                    itemSize: 30.0,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            );
    }

    Widget _buildBio(BuildContext context) {
      TextStyle bioTextStyle = TextStyle(
        fontFamily: 'Spectral',
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: Colors.white,
        fontSize: 16.0,
      );

      return Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          widget.model.bio,
          textAlign: TextAlign.center,
          style: bioTextStyle,
        ),
      );
    }

    Widget _buildSeparator(Size screenSize) {
      return Container(
        width: screenSize.width / 1.6,
        height: 2.0,
        color: Colors.white54,
        margin: EdgeInsets.only(top: 4.0),
      );
    }

    Widget _buildGetInTouch(BuildContext context) {
      return (flag == true)
          ? Container(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Get in Touch with ${widget.model.firstName} ${widget.model.lastName},",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () =>
                            launch("tel:${widget.model.phone.toString()}"),
                      ),
                      Text(
                        "${widget.model.phone}",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  )
                ],
              ))
          : Container(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.model.message == null
                        ? "No Message."
                        : widget.model.message,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        color: Color.fromRGBO(63, 169, 245, 1)),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Get in Touch with ${widget.model.firstName} ${widget.model.lastName},",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        onPressed: () =>
                            launch("tel:${widget.model.phone.toString()}"),
                      ),
                      Text(
                        "${widget.model.phone}",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  )
                ],
              ));
    }

    Size screenSize = MediaQuery.of(context).size;

    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    Widget _buildButtons() {
      return flag == false
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: isLoading == true
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final String token = prefs.getString('token');
                              String _headersKey = "Authorization";
                              String _headersValue = "Token " + token;

                              await http.get(
                                  "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/hire/approve/?hireid=${widget.model.reqId}",
                                  headers: {
                                    _headersKey: _headersValue,
                                    'Content-Type': 'application/json'
                                  });
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            },
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(63, 169, 245, 1)),
                          color: Color.fromRGBO(63, 169, 245, 1),
                        ),
                        child: Center(
                          child: Text(
                            "APPROVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OtherTripPage(widget.model))),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(63, 169, 245, 1)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "FEEDS",
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
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context, builder: (_) => hireForm());
                          },
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(63, 169, 245, 1)),
                              color: Color.fromRGBO(63, 169, 245, 1),
                            ),
                            child: Center(
                              child: Text(
                                "HIRE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OtherTripPage(widget.model))),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(63, 169, 245, 1)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "FEEDS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(63, 169, 245, 1)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context, builder: (_) => reviewForm());
                          },
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(63, 169, 245, 1)),
                              color: Color.fromRGBO(63, 169, 245, 1),
                            ),
                            child: Center(
                              child: Text(
                                "RATE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewPage(
                                      id: widget.model.id,
                                      name: widget.model.firstName,
                                    ))),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(63, 169, 245, 1)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "REVIEWS",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(63, 169, 245, 1)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ));
    }

    var movieInformation = (flag == false)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.firstName + " " + widget.model.lastName,
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: 8.0),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text("English"),
                      labelStyle: Theme.of(context).textTheme.caption,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text("Nepali"),
                      labelStyle: Theme.of(context).textTheme.caption,
                      backgroundColor: Colors.white12,
                    ),
                  )
                ],
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.firstName + " " + widget.model.lastName,
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: 8.0),
              RatingInformation(widget.model.rating),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text(widget.model.price == null
                          ? "Free"
                          : widget.model.price),
                      labelStyle: Theme.of(context).textTheme.caption,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 8.0),
                  //   child: Chip(
                  //     label: Text("Nepali"),
                  //     labelStyle: Theme.of(context).textTheme.caption,
                  //     backgroundColor: Colors.white12,
                  //   ),
                  // )
                ],
              )
            ],
          );

    Widget topContent() {
      return Container(
        height: screenSize.height / 2.29,
        child: Stack(children: <Widget>[
          _buildCoverImage(screenSize),
          Stack(
            children: <Widget>[
              _buildProfileImage(screenSize),
            ],
          )
        ]),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(63, 169, 245, 1),
      body: Card(
          child: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 140.0),
                        child: ArcBannerImage("assets/images/logo.png"),
                      ),
                      Positioned(
                          bottom: 0.0,
                          left: 16.0,
                          right: 16.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Poster(
                                  widget.model.profilepic,
                                  height: 180.0,
                                ),
                                SizedBox(width: 16.0),
                                Expanded(child: movieInformation),
                              ])),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Storyline(widget.model.bio),
                    ),
                    _buildSeparator(screenSize),
                    SizedBox(height: 10.0),
                    _buildGetInTouch(context),
                    SizedBox(height: 8.0),
                    _buildButtons(),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
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
