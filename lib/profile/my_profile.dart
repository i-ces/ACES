import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/authentication/authentication_bloc.dart';
import 'package:ghumnajaam/profile/arc_banner_image.dart';
import 'package:ghumnajaam/profile/feeds.dart';
import 'package:ghumnajaam/profile/guideRequest.dart';
import 'package:ghumnajaam/profile/poster.dart';
import 'package:ghumnajaam/profile/rating_information.dart';
import 'package:ghumnajaam/profile/reviews.dart';
import 'package:ghumnajaam/profile/story_line.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class UserProfilePage extends StatefulWidget {
  final AccountModel model;
  UserProfilePage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserProfilePage();
  }
}

class _UserProfilePage extends State<UserProfilePage> {
  bool flag;

  Position userLocation;
  Geolocator geolocator = Geolocator();
  @override
  initState() {
    super.initState();
    getFlag().then((f) {
      setState(() {
        flag = f;
      });
    });
    _getLocation().then((position) {
      this.setState(() {
        userLocation = position;
      });
      print(position.accuracy);
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> getFlag() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool flag1 = prefs.getBool('flag');
    return flag1;
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
                borderRadius: BorderRadius.circular(60.0),
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
        color: Colors.black,
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
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    Widget _buildStatItem(String count) {
      TextStyle _statCountTextStyle = TextStyle(
        color: Colors.black54,
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
      return (flag == true)
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
                    itemSize: 18.0,
                    physics: NeverScrollableScrollPhysics(),
                    unratedColor: Colors.amber.withAlpha(50),
                  ),
                ],
              ),
            );
    }

    Widget _buildBio(BuildContext context) {
      TextStyle bioTextStyle = TextStyle(
        fontFamily: 'Spectral',
        fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
        fontStyle: FontStyle.italic,
        color: Colors.black,
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
        color: Colors.black54,
        margin: EdgeInsets.only(top: 4.0),
      );
    }

    Widget _buildGetInTouch(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          "Get in Touch with ${widget.model.firstName} ${widget.model.lastName},",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
        ),
      );
    }

    Size screenSize = MediaQuery.of(context).size;

    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    Widget _buildButtons() {
      return (flag == true)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TripPage())),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "FEEDS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
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
                              builder: (context) => GuideRequest())),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "REQUESTS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
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
              child: Row(
                children: <Widget>[
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
                            color: Colors.redAccent,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "REVIEWS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TripPage())),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "FEEDS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
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
                              builder: (context) => GuideRequest())),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "REQUESTS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }

    Widget _buildButtons2() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  authenticationBloc.add(LoggedOut());
                },
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent,
                    ),
                    color: Colors.redAccent,
                  ),
                  child: Center(
                    child: Text(
                      "LOGOUT",
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
      );
    }

    var movieInformation = (flag == true)
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
                      backgroundColor: Colors.black12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text("Nepali"),
                      labelStyle: Theme.of(context).textTheme.caption,
                      backgroundColor: Colors.black12,
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
                      label: widget.model.price == null
                          ? Text(0.toString())
                          : Text(widget.model.price),
                      labelStyle: Theme.of(context).textTheme.caption,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ],
              )
            ],
          );
    Widget topContent() {
      return Container(
          height: screenSize.height / 2.29,
          child: Stack(
            children: <Widget>[
              _buildCoverImage(screenSize),
              Stack(
                children: <Widget>[
                  _buildProfileImage(screenSize),
                ],
              )
              // Stack(
              //   children: [

              //         ],
              //       ),
            ],
          ));
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
                child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Card(
                child: Column(
                  children: <Widget>[
                    //   topContent(),
                    Stack(children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 140.0),
                          child: Stack(
                            children: <Widget>[
                              ArcBannerImage(
                                "assets/images/logo.png",
                              ),
                              Positioned(
                                top: 20,
                                right: 0,
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(28.0),
                                          topLeft: Radius.circular(28.0))),
                                  splashColor: Colors.redAccent,
                                  color: Colors.red,
                                  child: new Row(children: <Widget>[
                                    new Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Emergency !!!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ]),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text('Emergency Request!'),
                                              content: Text(
                                                  "Do you wanna submit your request for state of emergency."),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Yes'),
                                                  onPressed: () async {
                                                    final SharedPreferences
                                                        prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final String token = prefs
                                                        .getString('token');
                                                    String _headersKey =
                                                        "Authorization";
                                                    String _headersValue =
                                                        "Token " + token;
                                                    await http.get(
                                                        'https://4fd81aa6.ngrok.io/api/accounts/emergency/?latitude=${userLocation.latitude}&longitude=${userLocation.longitude}',
                                                        headers: {
                                                          _headersKey:
                                                              _headersValue,
                                                          'Content-Type':
                                                              'application/json'
                                                        });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  },
                                ),
                              ),
                            ],
                          )),
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
                    SizedBox(height: 8.0), SizedBox(height: 8.0),
                    _buildButtons2(),
                  ],
                ),
              ),
            )),
          )
        ],
      ),
    );
  }
}
