import 'package:flutter/material.dart';
import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/login/login.dart';
import 'package:ghumnajaam/login/SignUp.dart';
import 'package:ghumnajaam/login_bloc/login.dart';
import 'package:ghumnajaam/user_repository.dart';

class FirstScreen extends StatefulWidget {
  final UserRepository userRepository;

  FirstScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _FirstScreen createState() => new _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> with TickerProviderStateMixin {
  AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.add(AppStarted());

    super.initState();
  }

  Widget HomePage() {
    double pad = MediaQuery.of(context).size.width * 0.5;
    return new Container(
      height: MediaQuery.of(context).size.height,
      child: new Column(
        children: <Widget>[
          new ClipPath(
            clipper: MyClipper(),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 400.0),
              child: Column(
                children: <Widget>[],
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, right: pad),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(28.0),
                            topRight: Radius.circular(28.0))),
                    splashColor: Colors.redAccent,
                    color: Colors.redAccent,
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        new Expanded(
                          child: Container(),
                        ),
                        new Transform.translate(
                          offset: Offset(15.0, 0.0),
                          child: new Container(
                            width: 60,
                            padding: const EdgeInsets.only(right: 5),
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(28.0),
                                      topRight: Radius.circular(28.0))),
                              splashColor: Colors.redAccent,
                              color: Colors.redAccent,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => {gotoLogin()},
                            ),
                          ),
                        )
                      ],
                    ),
                    onPressed: () => {gotoLogin()},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: pad),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28.0),
                            topLeft: Radius.circular(28.0))),
                    splashColor: Colors.redAccent,
                    color: Colors.redAccent,
                    child: new Row(
                      children: <Widget>[
                        new Transform.translate(
                          offset: Offset(0.0, 0.0),
                          child: new Container(
                            width: 30,
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(28.0),
                                      topLeft: Radius.circular(28.0))),
                              splashColor: Colors.redAccent,
                              color: Colors.redAccent,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onPressed: () => {gotoSignUp()},
                            ),
                          ),
                        ),
                        new Expanded(
                          child: Container(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => {gotoSignUp()},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignUp() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              LoginPage(userRepository: _userRepository),
              HomePage(),
              SignUpScreen(userRepository: _userRepository)
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}
