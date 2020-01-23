import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpInitial extends LoginState {
  @override
  String toString() => 'SignUpInitial';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpLoading extends LoginState {
  @override
  String toString() => 'SignUpLoading';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpFailure extends LoginState {
  final String error;

  SignUpFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'SignUpFailure { error: $error }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
