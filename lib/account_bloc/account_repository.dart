import 'dart:async';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  AccountModel _account;
  List<AccountModel> _accountList;
  Future<AccountModel> loadAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final bool flag = prefs.getBool('flag');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;
    print(_headersValue);
    await http.get("https://b5d3b73b.ngrok.io/api/accounts/profile/", headers: {
      _headersKey: _headersValue,
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      if (flag == false) {
        _account = new AccountModel(
            email: jsonData[0]['email'],
            firstName: jsonData[0]['first_name'],
            lastName: jsonData[0]['last_name'],
            username: jsonData[0]['username'],
            profilepic: jsonData[0]['guideprofile']['profile_pic'],
            lattitude: double.parse(jsonData[0]['guideprofile']['latitude']),
            longitude: double.parse(jsonData[0]['guideprofile']['longitude']),
            phone: jsonData[0]['guideprofile']['phone_number'],
            bio: jsonData[0]['guideprofile']['bio'],
            price: jsonData[0]['guideprofile']['pricing'].toString(),
            rating: (jsonData[0]['guideprofile']['rating'] + 0.0));

        print(_account);
      } else {
        print("tourist");
        _account = AccountModel(
            email: jsonData[0]['email'],
            firstName: jsonData[0]['first_name'],
            lastName: jsonData[0]['last_name'],
            username: jsonData[0]['username'],
            phone: jsonData[0]['touristprofile']['phone_number'],
            profilepic: jsonData[0]['touristprofile']['profile_pic'],
            bio: jsonData[0]['touristprofile']['bio'],
            rating: double.parse((0.0).toString() ?? "0.0"));
      }
      prefs.setString('name', _account.firstName + " " + _account.lastName);
    });
    print(_account);
    return _account;
  }

  Future<List<AccountModel>> fetchGuides() async {
    await http.get("https://b5d3b73b.ngrok.io/api/accounts/topguides/",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData1 = json.decode(response.body);

      List<AccountModel> accounts = [];
      jsonData1.forEach((jsonData) {
        AccountModel account = AccountModel(
            id: jsonData['user']['id'],
            email: jsonData['user']['email'],
            firstName: jsonData['user']['first_name'],
            lastName: jsonData['user']['last_name'],
            username: jsonData['user']['username'],
            profilepic: jsonData['profile_pic'],
            lattitude: double.parse(jsonData['latitude']),
            longitude: double.parse(jsonData['longitude']),
            phone: jsonData['phone_number'],
            bio: jsonData['bio'],
            price: jsonData['pricing'].toString(),
            rating: (jsonData['rating'] + 0.0));
        accounts.add(account);
      });
      _accountList = accounts;
    });
    return _accountList;
  }

  Future<List<AccountModel>> fetchSelectedGuides(double lat, double lng) async {
    await http.get(
        "https://b5d3b73b.ngrok.io/api/accounts/guides/?latitude=$lat&longitude=$lng",
        headers: {
          'Content-Type': 'application/json',
        }).then((http.Response response) {
      print("object1234");
      var jsonData1 = json.decode(response.body);
      List<AccountModel> accounts = [];
      jsonData1.forEach((jsonData) {
        AccountModel account = AccountModel(
            id: jsonData['id'],
            email: jsonData['user']['email'],
            firstName: jsonData['user']['first_name'],
            lastName: jsonData['user']['last_name'],
            username: jsonData['user']['username'],
            profilepic: jsonData['profile_pic'],
            lattitude: double.parse(jsonData['latitude']),
            longitude: double.parse(jsonData['longitude']),
            phone: jsonData['phone_number'],
            price: jsonData['pricing'].toString(),
            bio: jsonData['bio'],
            rating: (jsonData['rating'] + 0.0));
        accounts.add(account);
      });
      _accountList = accounts;
    });
    print(_accountList);
    return _accountList;
  }
}
