import 'dart:async';

import 'package:ghumnajaam/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:ghumnajaam/authentication/authentication.dart';
import 'package:ghumnajaam/login_bloc/login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final String token = await userRepository.authenticate(
          email: event.username,
          password: event.password,
        );
        final bool flag = await userRepository.flagResult();
        authenticationBloc.add(LoggedIn(token: token, flag: flag));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
    if (event is ErrorButton) {
      yield SignUpInitial();
    }
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      try {
        final token = await userRepository.signUp(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            username: event.username,
            password: event.password,
            phone: event.phone,
            location: event.location,
            lattitude: event.lattitude,
            longitude: event.longitude,
            bio: event.bio,
            price: event.price,
            image: event.profile);

        authenticationBloc.add(SignedUp());
      } catch (error) {
        yield SignUpFailure(error: error.toString());
      }
    }
    if (event is TouristSignUpButtonPressed) {
      yield SignUpLoading();

      try {
        final token = await userRepository.touristsignUp(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            username: event.username,
            password: event.password,
            phone: event.phone,
            bio: event.bio,
            image: event.profile);
        print(token);
        if (token == true) {
          authenticationBloc.add(SignedUp());
        }
      } catch (error) {
        yield SignUpFailure(error: error.toString());
      }
    }
  }
}
