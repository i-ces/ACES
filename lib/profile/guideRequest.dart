import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GuideRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuideRequest();
  }
}

class _GuideRequest extends State<GuideRequest> {
  bool flag;
  List<bool> isThreeLines = [];
 

  Future<bool> getFlag() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool flag1 = prefs.getBool('flag');
    return flag1;
  }

  Widget _pendingView(BuildContext context) {
    return FutureBuilder(
      
      builder: (BuildContext context, AsyncSnapshot snaps) {
        //  print(model.notices);

        return snaps.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                shrinkWrap: true,
                itemCount: snaps.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    contentPadding:
                        EdgeInsets.only(top: 10, left: 10, right: 10),
                    leading: CircleAvatar(
                      backgroundImage: (snaps.data[index].profilepic == null)
                          ? AssetImage("assets/images/visitnepal.png")
                          : NetworkImage(snaps.data[index].profilepic),
                    ),
                    title: Text(snaps.data[index].firstName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: flag == false
                        ? RaisedButton(
                            child: Text(
                              "Approve",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color.fromRGBO(63, 169, 245, 1),
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final String token = prefs.getString('token');
                              String _headersKey = "Authorization";
                              String _headersValue = "Token " + token;
                              await http.get(
                                  "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/hire/approve/?hireid=${snaps.data[index].reqId}",
                                  headers: {
                                    _headersKey: _headersValue,
                                    'Content-Type': 'application/json'
                                  });
                            },
                          )
                        : RaisedButton(
                            child: Text(
                              "Check Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color.fromRGBO(63, 169, 245, 1),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => OtherProfilePage(
                              //               model: snaps.data[index],
                              //             )));
                            },
                          ),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OtherProfilePage(
                      //               model: snaps.data[index],
                      //             )));
                    },
                  ));
                },
              )
            : Center(
                child: RefreshProgressIndicator(),
              );
      },
    );
  }

  Widget _approvedView(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snaps) {
        //  print(model.notices);

        return snaps.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(left: 10.0),
                shrinkWrap: true,
                itemCount: snaps.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    contentPadding:
                        EdgeInsets.only(top: 10, left: 10, right: 10),
                    leading: CircleAvatar(
                      backgroundImage: (snaps.data[index].profilepic == null)
                          ? AssetImage("assets/images/visitnepal.png")
                          : NetworkImage(snaps.data[index].profilepic),
                    ),
                    title: Text(snaps.data[index].firstName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: RaisedButton(
                      child: Text("Check Profile"),
                      color: Color.fromRGBO(63, 169, 245, 1),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OtherProfilePage(
                        //               model: snaps.data[index],
                        //             )));
                      },
                    ),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OtherProfilePage(
                      //               model: snaps.data[index],
                      //             )));
                    },
                  ));
                },
              )
            : Center(
                child: RefreshProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('My Requests', textAlign: TextAlign.center),
              backgroundColor: Color.fromRGBO(63, 169, 245, 1),
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "Pending ",
                  ),
                  Tab(text: "Approved"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
              ],
            )));
  }
}
