import 'package:flutter/material.dart';
import 'package:ghumnajaam/trip/index.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/gestures.dart';

class ReviewPage extends StatefulWidget {
  final int id;
  final String name;
  ReviewPage({this.id, this.name});
  @override
  State<StatefulWidget> createState() {
    return _ReviewPage();
  }
}

class _ReviewPage extends State<ReviewPage> {
  TripRepository model = TripRepository();
  @override
  initState() {
    TripRepository().fetchReviews(widget.id);
    super.initState();
  }

  Widget _reviewView(BuildContext context, TripRepository model) {
    return FutureBuilder(
      future: model.fetchReviews(widget.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                dragStartBehavior: DragStartBehavior.down,
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 10.0),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: new ListTile(
                        title: new Text(
                          snapshot.data[index].name,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                RatingBarIndicator(
                                  rating: snapshot.data[index].rating,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  physics: NeverScrollableScrollPhysics(),
                                  unratedColor: Colors.amber.withAlpha(50),
                                ),
                              ],
                            ),
                            Text(
                              snapshot.data[index].review,
                            )
                          ],
                        )),
                  );
                })
            : Center(child: RefreshProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.name, textAlign: TextAlign.center),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.redAccent,
            child: _reviewView(context, TripRepository())));
  }
}
