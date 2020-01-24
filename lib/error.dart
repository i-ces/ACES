import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("GhumnaJam"),
            backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          ),
          body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Text(
                  "Please connect to wifi or turn on mobile data to explore nepal.",
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color.fromRGBO(63, 169, 245, 1),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ])),
        ));
  }
}
