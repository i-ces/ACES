import 'package:flutter/material.dart';
import 'package:ghumnajaam/food.json';

class FoodPanel extends StatefulWidget {
  FoodPanel({Key key}) : super(key: key);

  @override
  _FoodPanelState createState() => _FoodPanelState();
}

class _FoodPanelState extends State<FoodPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                itemCard('assets/apple.jpg', 'Apple', 50, context),
                itemCard('assets/banana.jpg', 'Banana', 90, context)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                itemCard('assets/lemons.jpg', 'Lemon', 20, context),
                itemCard('assets/kiwi.jpg', 'Kiwi', 200, context)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                itemCard('assets/grapes.jpg', 'Grapes', 150, context),
                itemCard('assets/pineapple.jpg', 'Pineapple', 190, context),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

Widget itemCard(imagename, itmname, itmprice, context) {
  return SafeArea(
      top: false,
      bottom: false,
      child: Container(
          height: 250.0,
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () {},
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Image.asset(
                            imagename,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {}),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            itmname,
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'Rs :' + ' $itmprice',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => Container(
                      alignment: Alignment.center,
                      child: OutlineButton(
                          borderSide: BorderSide(color: Colors.red.shade500),
                          child: const Text('Add'),
                          onPressed: () {},
                          shape: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )));
}
