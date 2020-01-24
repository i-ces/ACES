import 'package:flutter/material.dart';
import 'package:ghumnajaam/trek_details/home.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text("GhumnaJam"),
                    backgroundColor: Colors.redAccent,
                  ),
                  body: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text(
                          "No Wifi, No Problem. Click to visit nepal offline",
                          textAlign: TextAlign.center,
                        ),
                        FlatButton(
                            child: Text(
                              "Open",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OffHome()))),
                      ])),
                )));
  }
}
