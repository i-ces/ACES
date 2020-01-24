import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class GuideHome extends StatefulWidget {
  const GuideHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GuideHome();
  }
}

class _GuideHome extends State<GuideHome> {
  bool status;
  @override
  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> getConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool flag;
    if (connectivityResult == ConnectivityResult.mobile) {
      flag = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      flag = true;
    } else {
      flag = false;
    }
    return flag;
  }

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color.fromRGBO(63, 169, 245, 1),
          height: 60,
          items: <Widget>[
            Icon(
              Icons.account_circle,
              size: 30,
              color: Color.fromRGBO(63, 169, 245, 1),
            ),
            Icon(
              Icons.train,
              size: 30,
              color: Color.fromRGBO(63, 169, 245, 1),
            ),
          ],
          animationCurve: Curves.bounceOut,
          animationDuration: Duration(milliseconds: 400),
          onTap: (index) {
            switch (index) {
              case 0:
                _controller.animateToPage(
                  0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.bounceOut,
                );
                break;
              case 1:
                _controller.animateToPage(
                  1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.bounceOut,
                );
                break;

              default:
            }
          },
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              children: <Widget>[],
            )),
      ),
    );
  }
}
