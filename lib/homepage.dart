import 'package:flutter/material.dart';
import 'package:ghumnajaam/hotelList.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        appBar: new AppBar(
          elevation: 0,
          title: new Text(
            "Ghumna Jaam",
            style: new TextStyle(
              color: Colors.redAccent,
              fontFamily: "Cursive",
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          //backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              card(),
              card(),
              card(),
              FlatButton(
                onPressed: (){
                  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HotelList()));
                },
                child: Text("Hotel page"),
              ),
            ],
          ),
        ));
  }

  Widget card() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 12.0,
              ),
              Container(
                child: CircleAvatar(
                  foregroundColor: Colors.red,
                  backgroundImage: ExactAssetImage('assets/download.jpg'),
                  minRadius: 10,
                  maxRadius: 14,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                "Posted by: ",
                style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/hotelview1.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 12.0,
              ),
              Icon(
                Icons.star_border,
                color: Colors.redAccent,
                size: 35.0,
              ),
              SizedBox(
                width: 12.0,
              ),
              Icon(
                Icons.insert_comment,
                color: Colors.black87,
                size: 35.0,
              ),
            ],
          ),
          SizedBox(
            height: 3.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
              style: new TextStyle(
                color: Colors.black45,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
