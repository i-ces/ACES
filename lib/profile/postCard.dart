import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghumnajaam/profile/feeds.dart';
import 'package:ghumnajaam/trip/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TripModelCard extends StatelessWidget {
  final List<TripModel> postList;
  TripModelCard(this.postList);
  Widget profileColumn(BuildContext context, TripModel post) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: post.profilePic == null
                ? AssetImage("assets/images/mountains.jpg")
                : NetworkImage(post.profilePic),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.name == null ? "ghumnajaam" : post.name,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .apply(fontWeightDelta: 700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  post.address,
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
                  "http://ec2-52-87-169-94.compute-1.amazonaws.com/api/trip/delete/?tripid=${post.id}",
                  headers: {
                    _headersKey: _headersValue,
                    'Content-Type': 'application/json'
                  });
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TripPage()));
            },
          )
        ],
      );

  //column last

  //column last
  Widget actionColumn(TripModel post) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              post.time == null ? "Moment ago" : post.time,
            ),
            RatingBarIndicator(
              rating: (post.rating + 0.0).toDouble(),
              itemCount: 5,
              itemSize: 18.0,
              physics: NeverScrollableScrollPhysics(),
              unratedColor: Colors.amber.withAlpha(50),
            ),
          ],
        ),
      );

  //post cards
  Widget postCard(BuildContext context, TripModel post) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileColumn(context, post),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.details,
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
                    child: Image.network(post.urls),
                  ))),
          actionColumn(post),
        ],
      ),
    );
  }

  Widget bodyList(List<TripModel> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: postCard(context, posts[index]),
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
