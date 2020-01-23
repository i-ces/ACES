import 'package:flutter/material.dart';
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
  @override
  Widget _reviewView(BuildContext context) {
    return FutureBuilder(
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
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(63, 169, 245, 1),
            child: _reviewView(context)));
  }
}
