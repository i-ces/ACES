import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:ghumnajaam/tourist/myTrip.dart';
import 'package:ghumnajaam/trek_details/trek.dart';
import 'package:ghumnajaam/trek_details/trek_detail.dart';

class TrekHome extends StatefulWidget {
  @override
  TrekHomeState createState() {
    return new TrekHomeState();
  }
}

class TrekHomeState extends State<TrekHome> {
  List<Trek> trekLists = [];
  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _loadProductAsset() async {
    return await rootBundle.loadString('assets/trek.json');
  }

  Future loadProduct() async {
    String jsonProduct = await _loadProductAsset();
    final jsonResponse = json.decode(jsonProduct);

    List<Trek> trekList = [];
    jsonResponse.forEach((data) {
      Trek trek = Trek.fromJson(data);
      trekList.add(trek);
    });
    setState(() {
      trekLists = trekList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/mountains.jpg"))),
      ),
      Padding(
          padding: EdgeInsets.only(top: 150),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80)),
                color: Colors.white,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        itemCount: trekLists.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 5.0,
                              child: ListTile(
                                dense: false,
                                contentPadding: EdgeInsets.all(10),
                                leading: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage(trekLists[index].image)),
                                title: Text("${trekLists[index].trek_name}"),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TrekDetail(trekLists[index]))),
                              ));
                        })
                  ])))
    ]));
  }
}
