import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OtherTripModelCard extends StatelessWidget {
  final List postList;
  OtherTripModelCard(this.postList);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                       "GhumnaJam",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .apply(fontWeightDelta: 700),
                    ),
                    Text(
                       "Moment ago" ,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "address",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.pink),
                )
              ],
            ),
          )),
        ],
      );

  //column last

  //column last
  Widget actionColumn() => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
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
            child: profileColumn(context),
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
                    child: Image.network("Network Image"),
                  ))),
          actionColumn(),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "details",
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyList(List posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: postCard(context),
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
