import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/profile/feeds.dart';
import 'package:ghumnajaam/tourist/myTrip.dart';
import 'package:ghumnajaam/trip/index.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({
    Key key,
    @required TripBloc tripBloc,
  })  : _tripBloc = tripBloc,
        super(key: key);

  final TripBloc _tripBloc;

  @override
  TripScreenState createState() {
    return new TripScreenState(_tripBloc);
  }
}

class TripScreenState extends State<TripScreen> {
  final TripBloc _tripBloc;
  TripScreenState(this._tripBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(
        bloc: widget._tripBloc,
        builder: (
          BuildContext context,
          TripState currentState,
        ) {
          if (currentState is ErrorTripState) {
            return new Container(
                child: new Center(
              child: new Text(currentState.errorMessage ?? 'Error'),
            ));
          }
          return MyTrip(
            tripBloc: _tripBloc,
          );
        });
  }
}
