import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/guides_bloc.dart';
import 'package:ghumnajaam/account_bloc/index.dart';
import 'package:ghumnajaam/error.dart';
import 'package:ghumnajaam/tourist/user_details_page.dart';
import 'package:ghumnajaam/trek_details/trek_home.dart';
import 'package:ghumnajaam/trip/index.dart';
import 'package:ghumnajaam/trip/trip_bloc.dart';

class TouristHome extends StatefulWidget {
  final AccountRepository accountRepository;

  const TouristHome({Key key, this.accountRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TouristHome();
  }
}

// ignore: must_be_immutable
class _TouristHome extends State<TouristHome> {
  AccountBlocBloc _accountBlocBloc;
  GuidesBloc _guideBloc;
  TripBloc _tripBloc;
  Geolocator geolocator = Geolocator();
  Position userLocation;

  bool status;
  @override
  void initState() {
    getConnection().then((f) {
      setState(() {
        status = f;
      });
    });
    _getLocation().then((position) {
      userLocation = position;
    });
    _accountBlocBloc =
        AccountBlocBloc(accountRepository: widget.accountRepository);
    _tripBloc = TripBloc(TripRepository());
    _guideBloc = GuidesBloc(accountRepository: widget.accountRepository);
    _accountBlocBloc.add(LoadAccountBlocEvent());
    _guideBloc.add(LoadGuidesBlocEvent());
  }

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
    return status == false
        ? ErrorPage()
        : BlocProvider(
            child: Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.lightBlue,
                color: Colors.white,
                height: 60,
                items: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors.lightBlue,
                  ),
                  Icon(Icons.train, size: 30, color: Colors.lightBlue),
                  Icon(Icons.map, size: 30, color: Colors.lightBlue),
                ],
                animationCurve: Curves.easeInOutQuad,
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
                    case 2:
                      _controller.animateToPage(
                        2,
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
                    physics: new NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      UserDetailsPage(),
                      TripScreen(tripBloc: _tripBloc),
                      TrekHome()
                    ],
                  )),
            ),
            create: (context) => _accountBlocBloc,
          );
  }

  Future<Position> _getLocation() async {
    Position currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
