import 'dart:io';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorButton extends LoginEvent {
  @override
  String toString() => 'LoginButtonPressed';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SignUpButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String location;
  final double lattitude;
  final double longitude;
  final String bio;
  final String price;
  final File profile;
  SignUpButtonPressed({
    @required this.username,
    @required this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.price,
    this.phone,
    this.location,
    this.lattitude,
    this.longitude,
    this.bio,
    this.profile,
  });
  @override
  String toString() =>
      'SignUpButtonPressed { username: $username, password: $password }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class TouristSignUpButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  final String bio;
  final File profile;
  TouristSignUpButtonPressed({
    @required this.username,
    @required this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.bio,
    this.profile,
  });
  @override
  String toString() =>
      'SignUpButtonPressed { username: $username, password: $password }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
