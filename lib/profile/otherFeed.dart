import 'package:flutter/material.dart';

class OtherTripPage extends StatefulWidget {
  
 
  @override
  State<StatefulWidget> createState() {
    return _OtherTripPage();
  }
}

class _OtherTripPage extends State<OtherTripPage> {
  List<bool> isThreeLines = [];
 

  Widget _eventView(BuildContext context) {
    return FutureBuilder(
      
      builder: (BuildContext context, AsyncSnapshot snaps) {
        //  print(model.notices);

        return Center(child: RefreshProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("first Name", textAlign: TextAlign.center),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(63, 169, 245, 1),
            child: _eventView(context)));
  }
}
