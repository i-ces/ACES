import 'dart:async';

import 'package:ghumnajaam/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:ghumnajaam/authentication/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final String token = await userRepository.hasToken();
      final bool flag = await userRepository.flagResult();
      if (token != null) {
        if (flag == true) {
          yield TouristAuthenticationAuthenticated();
        } else {
          yield AuthenticationAuthenticated();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is SignedUp) {
      print("signUp");
      yield SignUpFinished();
    }
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      final String token = await userRepository.hasToken();
      final bool flag = await userRepository.flagResult();

      if (flag) {
        yield TouristAuthenticationAuthenticated();
      } else {
        yield AuthenticationAuthenticated();
      }
    }
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
