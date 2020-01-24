import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/profile/other_profile.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyCqOpyZcoDGRaOk10J46AVLfBHdWXVdn0g";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchGuideListWidget extends StatefulWidget {
  LatLng latLng;

  SearchGuideListWidget(this.latLng);

  @override
  State<StatefulWidget> createState() {
    return SearchGuideListState();
  }
}

class SearchGuideListState extends State<SearchGuideListWidget> {
  GoogleMapController mapController;
  PlacesDetailsResponse place;
  bool isLoading = false;
  String errorLoading;
  Set<Marker> _marker = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guides"),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition:
                          CameraPosition(target: widget.latLng, zoom: 15.0),
                      myLocationEnabled: true,
                      markers: _marker,
                    ))),
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Color.fromRGBO(63, 169, 245, 1),
              padding: EdgeInsets.all(20),
              child: Card(
                child:
                    guideList(widget.latLng.latitude, widget.latLng.longitude),
              ),
            ))
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final center = widget.latLng;
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId("place"),
          position: center,
          infoWindow: InfoWindow(
            title: "Selected Place",
          )));
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
  }

  Widget guideList(double lat, double lng) {
    return FutureBuilder(
      future: AccountRepository().fetchSelectedGuides(lat, lng),
      builder: (BuildContext context, AsyncSnapshot snaps) {
        return snaps.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(left: 10.0),
                shrinkWrap: true,
                itemCount: snaps.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snaps.data[index].profilepic),
                        ),
                        title: new Text(
                          snaps.data[index].firstName +
                              " " +
                              snaps.data[index].lastName,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RatingBarIndicator(
                              rating: snaps.data[index].rating,
                              itemCount: 5,
                              itemSize: 18.0,
                              physics: NeverScrollableScrollPhysics(),
                              unratedColor: Colors.amber.withAlpha(50),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherProfilePage(
                                      model: snaps.data[index])));
                        }),
                  );
                },
              )
            : Center(
                child: RefreshProgressIndicator(),
              );
      },
    );
  }
}
