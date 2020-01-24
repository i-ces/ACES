import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/authentication/authentication.dart';

class TravelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(63, 169, 245, 1),
      child: Center(
          child: RaisedButton(
        child: Text('logout'),
        onPressed: () {
          authenticationBloc.add(LoggedOut());
        },
      )),
    );
  }
}
