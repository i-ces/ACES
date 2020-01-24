import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/login/login.dart';
import 'package:ghumnajaam/user_repository.dart';
import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/login_bloc/login.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: LoginScreen(
              loginBloc: _loginBloc,
              authenticationBloc: _authenticationBloc,
            )));
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
