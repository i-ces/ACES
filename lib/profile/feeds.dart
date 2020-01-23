import 'package:flutter/material.dart';
import 'package:ghumnaJam/profile/postCard.dart';
import 'package:ghumnaJam/trip/index.dart';

class TripPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TripPage();
  }
}

class _TripPage extends State<TripPage> {
  List<bool> isThreeLines = [];
  TripRepository model = TripRepository();
  @override
  initState() {
    model.fetchTrips();
    super.initState();
  }

  Widget _eventView(BuildContext context, TripRepository model) {
    return FutureBuilder(
      future: model.fetchTrips(),
      builder: (BuildContext context, AsyncSnapshot snaps) {
        //  print(model.notices);

        return snaps.hasData
            ? TripModelCard(snaps.data)
            : Center(child: RefreshProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('My Trips', textAlign: TextAlign.center),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(63, 169, 245, 1),
            child: _eventView(context, TripRepository())));
  }
}
