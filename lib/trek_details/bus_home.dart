import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghumnajaam/trek_details/bus.dart';

class BusHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BusHome();
  }
}

class _BusHome extends State<BusHome> {
  TextEditingController editingController = TextEditingController();
  List<Bus> busLists = [];

  final duplicateItems = List<Bus>();
  var items = List<Bus>();
  @override
  void initState() {
    super.initState();
    loadProduct().then((onValue) {
      this.setState(() {
        items.addAll(duplicateItems);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _loadProductAsset() async {
    return await rootBundle.loadString('assets/bus.json');
  }

  Future loadProduct() async {
    String jsonProduct = await _loadProductAsset();
    final jsonResponse = json.decode(jsonProduct);

    List<Bus> busList = [];
    jsonResponse.forEach((data) {
      Bus trek = Bus.fromJson(data);
      setState(() {
        duplicateItems.add(trek);
      });

      busList.add(trek);
    });
    setState(() {
      busLists = busList;
    });
  }

  void filterSearchResults(String query) {
    List<Bus> dummySearchList = List<Bus>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Bus> dummyListData = List<Bus>();
      dummySearchList.forEach((item) {
        if (item.to.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
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
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/bus.png"))),
        ),
        Padding(
          padding: EdgeInsets.only(top: 150),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80), topRight: Radius.circular(80)),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 5.0,
                          child: ListTile(
                            leading: Icon(Icons.directions_bus, size: 40),
                            title: Text(
                              '${items[index].to}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${items[index].price}',
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => Center(
                                          child: Container(
                                        height: 300,
                                        child: Card(
                                            margin: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    "${items[index].from}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text("From"),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      "${items[index].to}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle: Text("Destination"),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      "${items[index].price}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle:
                                                      Text("Average Bus Fare"),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      "${items[index].time}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle: Text(
                                                      "Average Travel Duration"),
                                                )
                                              ],
                                            )),
                                      )));
                            },
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
