import 'package:flutter/material.dart';

class User {
  final String email;
  final String token;
  final String firstName;
  final String lastName;
  final String userName;
  final bool flag;

  User(
      {
      //  @required this.id,
      @required this.email,
      @required this.token,
      this.firstName,
      this.flag,
      this.lastName,
      this.userName});
}
