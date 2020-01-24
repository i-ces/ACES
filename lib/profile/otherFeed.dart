import 'package:flutter/material.dart';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/profile/otherPostCard.dart';
import 'package:ghumnajaam/profile/postCard.dart';
import 'package:ghumnajaam/trip/index.dart';

class OtherTripPage extends StatefulWidget {
  final AccountModel model;
  OtherTripPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _OtherTripPage();
  }
}

class _OtherTripPage extends State<OtherTripPage> {
  List<bool> isThreeLines = [];
  TripRepository model = TripRepository();
  @override
  initState() {
    super.initState();
  }

  Widget _eventView(BuildContext context, TripRepository model) {
    return FutureBuilder(
      future: model.fetchOtherTrips(widget.model.id),
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
          title: Text(widget.model.firstName, textAlign: TextAlign.center),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(63, 169, 245, 1),
            child: _eventView(context, TripRepository())));
  }
}
