import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghumnajaam/account_bloc/account_repository.dart';
import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/error.dart';
import 'package:ghumnajaam/guide/guide_home.dart';
import 'package:ghumnajaam/login/first.dart';
import 'package:ghumnajaam/login_bloc/login.dart';
import 'package:ghumnajaam/tourist/tourist_home.dart';
import 'package:ghumnajaam/user_repository.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(App(userRepository: UserRepository()));
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;
  bool status;
  @override
  void initState() {
    getConnection().then((f) {
      setState(() {
        status = f;
      });
    });

    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.close();
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

  @override
  Widget build(BuildContext context) {
    return status == false
        ? ErrorPage()
        :
        //   MaterialApp(debugShowCheckedModeBanner: false, home: OffHome());
        BlocProvider<AuthenticationBloc>(
            create: (context) => _authenticationBloc,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                bloc: _authenticationBloc,
                builder: (BuildContext context, AuthenticationState state) {
                  if (state is AuthenticationUninitialized) {
                    return FirstScreen(userRepository: _userRepository);
                  }
                  if (state is AuthenticationAuthenticated) {
                    return GuideHome(accountRepository: AccountRepository());
                  }
                  if (state is TouristAuthenticationAuthenticated) {
                    //  return TouristHome();
                    return TouristHome(accountRepository: AccountRepository());
                  }
                  if (state is SignUpFinished) {
                    return LoginPage(userRepository: _userRepository);
                  }

                  if (state is AuthenticationUnauthenticated) {
                    return FirstScreen(userRepository: _userRepository);
                  }
                  if (state is AuthenticationLoading) {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          );
  }
}
