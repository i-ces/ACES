import 'package:flutter/material.dart';
import 'package:ghumnajaam/profile/postCard.dart';
import 'package:ghumnajaam/trip/index.dart';

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
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.redAccent,
            child: _eventView(context, TripRepository())));
  }
}
