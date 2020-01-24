import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/account_bloc/guides_bloc.dart';
import 'package:ghumnajaam/account_bloc/index.dart';
import 'package:ghumnajaam/tourist/nearbyGuide.dart';
import 'package:ghumnajaam/tourist/searchGuide.dart';

class PlacesSearch extends StatefulWidget {
  final AccountRepository accountRepository;

  const PlacesSearch({Key key, this.accountRepository}) : super(key: key);

  @override
  _PlacesSearch createState() => _PlacesSearch();
}

class _PlacesSearch extends State<PlacesSearch> {
  GuidesBloc _guidesBloc;
  Position userLocation;
  Geolocator geolocator = Geolocator();
  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      this.setState(() {
        userLocation = position;
      });
      print(position.accuracy);
    });
    _guidesBloc = GuidesBloc(accountRepository: widget.accountRepository);
    _guidesBloc.add(LoadGuidesBlocEvent());
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Guides"),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () => userLocation == null
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NearbyGuide(userLocation))))
              ],
              backgroundColor: Colors.redAccent,
            ),
            body: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    padding: EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: RaisedButton(
                        onPressed: null,
                        disabledColor: Colors.redAccent,
                        disabledElevation: 10.0,
                        child: Text(
                          "TOP GUIDES",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.redAccent,
                      ),
                    )),
                SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.63,
                      color: Colors.redAccent,
                      padding: EdgeInsets.only(top: 20),
                      child: GuidesSearch()),
                ),
                Expanded(
                  child: Container(
                    color: Colors.lightBlue,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            )),
        create: (context) => _guidesBloc);
  }
}
