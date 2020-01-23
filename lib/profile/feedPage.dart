import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPage();
  }
}

class _FeedPage extends State<FeedPage> {
  List<bool> isThreeLines = [];
  @override
  initState() {
    super.initState();
  }

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
          title: Text("Text", textAlign: TextAlign.center),
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(63, 169, 245, 1),
            child: _eventView(context)));
  }
}
