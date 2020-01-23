import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TripModelCard extends StatelessWidget {
  final List postList;
  TripModelCard(this.postList);
  Widget profileColumn(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage("Network Image"),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                   "GhumnaJam" ,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .apply(fontWeightDelta: 700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Address",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.pink),
                )
              ],
            ),
          )),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final String token = prefs.getString('token');
              String _headersKey = "Authorization";
              String _headersValue = "Token " + token;
              await http.get(
                  "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/trip/delete/?tripid=1234",
                  headers: {
                    _headersKey: _headersValue,
                    'Content-Type': 'application/json'
                  });
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => TripPage()));
            },
          )
        ],
      );

  //column last

  //column last
  Widget actionColumn() => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
               "Moment ago",
            ),
          ],
        ),
      );

  //post cards
  Widget postCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Text",
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
              height: 300.0,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: SizedBox(
                    height: 300,
                    child: Image.network("text"),
                  ))),
          Container(),
        ],
      ),
    );
  }

  Widget bodyList(List posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          );
        }, childCount: posts.length),
      );
  Widget bodySliverList() {
    return CustomScrollView(
      slivers: <Widget>[
        bodyList(postList),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodySliverList(),
    );
  }
}
