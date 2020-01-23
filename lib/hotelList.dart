import 'package:flutter/material.dart';

class HotelList extends StatefulWidget {
  HotelList({Key key}) : super(key: key);

  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
          child: Column(
            children: <Widget>[
              TextField(
                
              ),
            ],
          )
          ),
        ],
      )
    );
  }
}