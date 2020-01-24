import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/profile/other_profile.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyCqOpyZcoDGRaOk10J46AVLfBHdWXVdn0g";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class GuideListWidget extends StatefulWidget {
  String placeId;

  GuideListWidget(String placeId) {
    this.placeId = placeId;
  }

  @override
  State<StatefulWidget> createState() {
    return GuideListState();
  }
}

class GuideListState extends State<GuideListWidget> {
  GoogleMapController mapController;
  PlacesDetailsResponse place;
  bool isLoading = false;
  String errorLoading;
  Set<Marker> _marker = {};
  @override
  void initState() {
    fetchGuideList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyChild;
    String title;
    if (isLoading) {
      title = "Loading";
      bodyChild = Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (errorLoading != null) {
      title = "";
      bodyChild = Center(
        child: Text(errorLoading),
      );
    } else {
      final placeDetail = place.result;
      final location = place.result.geometry.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      title = placeDetail.name;
      bodyChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: center, zoom: 15.0),
                    myLocationEnabled: true,
                    markers: _marker,
                  ))),
          Expanded(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Color.fromRGBO(63, 169, 245, 1),
            padding: EdgeInsets.all(20),
            child: Card(
              child: guideList(lat, lng),
            ),
          ))
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          elevation: 0,
        ),
        body: bodyChild);
  }

  void fetchGuideList() async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = null;
    });

    PlacesDetailsResponse place =
        await _places.getDetailsByPlaceId(widget.placeId);

    if (mounted) {
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          this.place = place;
        } else {
          this.errorLoading = place.errorMessage;
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final placeDetail = place.result;
    final location = place.result.geometry.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId("place"),
          position: center,
          infoWindow: InfoWindow(
              title: "${placeDetail.name}",
              snippet: "${placeDetail.formattedAddress}")));
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
  }

  Widget guideList(double lat, double lng) {
    return FutureBuilder(
      future: AccountRepository().fetchSelectedGuides(lat, lng),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(left: 10.0),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data[index].profilepic),
                        ),
                        title: new Text(
                          snapshot.data[index].firstName +
                              " " +
                              snapshot.data[index].lastName,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RatingBarIndicator(
                              rating: snapshot.data[index].rating,
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
                                      model: snapshot.data[index])));
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
