import 'package:flutter/material.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/profile/otherPostCard.dart';
import 'package:ghumnajaam/profile/postCard.dart';
import 'package:ghumnajaam/trip/index.dart';

class FeedPage extends StatefulWidget {
  final String model;
  final String name;
  FeedPage({this.model, this.name});
  @override
  State<StatefulWidget> createState() {
    return _FeedPage();
  }
}

class _FeedPage extends State<FeedPage> {
  List<bool> isThreeLines = [];
  TripRepository model = TripRepository();
  @override
  initState() {
    super.initState();
  }

  Widget _eventView(BuildContext context, TripRepository model) {
    return FutureBuilder(
      future: model.fetchfeedTrips(widget.model),
      builder: (BuildContext context, AsyncSnapshot snaps) {
        //  print(model.notices);

        return snaps.hasData
            ? OtherTripModelCard(snaps.data)
            : Center(child: RefreshProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.name, textAlign: TextAlign.center),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.redAccent,
            child: _eventView(context, TripRepository())));
  }
}
