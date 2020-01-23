import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:ghumnajaam/trek_details/bus_home.dart';
import 'package:ghumnajaam/trek_details/food_home.dart';
import 'package:ghumnajaam/trek_details/hotels.dart';
import 'package:ghumnajaam/trek_details/trek_home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class OffHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OffHome();
  }
}

class _OffHome extends State<OffHome> {
  Future<void> _handlePressButton() async {
    try {
      final center = LatLng(27.690088, 85.368354);
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: 'AIzaSyCqOpyZcoDGRaOk10J46AVLfBHdWXVdn0g',
          mode: Mode.overlay,
          language: "en",
          location: center == null ? null : Location(27.690088, 85.368354),
          radius: center == null ? null : 400000);
      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      print(placeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        // Padding(
        //   child: Container(
        //       height: 200,
        //       child: Image.asset(
        //         "assets/images/logo.jpg",
        //         fit: BoxFit.contain,
        //       )),
        //   padding:
        //       EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.8),
        // ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          //    color: Colors.blue,
          decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/visitnepal.png"))),
        ),
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Container(
              margin: EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80)),
                color: Colors.white,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  InkWell(
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/bus.png",
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Bus Routes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BusHome())),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/hike.png",
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Trekking Routes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TrekHome())),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/khana.jpg",
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "  Food             ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FoodPage())),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/hotel.jpg",
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "  Hotel             ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HotelPage())),
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
