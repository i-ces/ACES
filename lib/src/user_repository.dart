import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ghumnajaam/models/user.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserRepository {
  User _authenticatedUser;
  PublishSubject<bool> _userSubject = PublishSubject();
  PublishSubject<bool> _isTourist = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  PublishSubject<bool> get isTourist {
    return _isTourist;
  }

  User get user {
    return _authenticatedUser;
  }

  Future<dynamic> authenticate({
    @required String email,
    @required String password,
  }) async {
    final Map<String, dynamic> authData = {
      'username': email,
      'password': password,
      // 'returnSecureToken': true
    };
    try {
      http.Response response;

      http.Response response2;

      response = await http.post(
        'https://4fd81aa6.ngrok.io/api/accounts/login/',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('token')) {
        String _headersKey = "Authorization";
        String _headersValue = "Token " + responseData['token'];

        response2 = await http.get(
          'https://4fd81aa6.ngrok.io/api/accounts/flag/',
          headers: {
            _headersKey: _headersValue,
            'Content-Type': 'application/json'
          },
        );
        final responseData2 = json.decode(response2.body);

        _authenticatedUser = User(
            email: email,
            token: responseData['token'],
            flag: responseData2.length == 0
                ? false
                : responseData2[0]['is_tourist']);
        print(_authenticatedUser.flag);
        return _authenticatedUser.token;
      } else {
        throw responseData['non_field_errors'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> flagResult() async {
    return _authenticatedUser.flag;
  }

  Future<void> deleteToken() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('flag');
    prefs.remove('userEmail');

    return;
  }

  Future<void> persistToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _authenticatedUser.token);
    prefs.setBool('flag', _authenticatedUser.flag);
    prefs.setString('userEmail', _authenticatedUser.email);
    return;
  }

  Future<String> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final bool flag = prefs.getBool('flag');

    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      _authenticatedUser = User(email: userEmail, token: token, flag: flag);
      return (token != null) ? token : null;
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST',
        Uri.parse('https://4fd81aa6.ngrok.io/api/accounts/profilepicture/'));
    final file = await http.MultipartFile.fromPath(
      'profile_pic',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['profile_pic'] = Uri.encodeComponent(imagePath);
    }

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> signUp(
      {String firstName,
      String lastName,
      String email,
      String username,
      String password,
      String phone,
      String location,
      double lattitude,
      double longitude,
      String price,
      String bio,
      File image}) async {
    bool hasError = true;
    try {
      final uploadedData = await uploadImage(image);
      print("called");
      final Map<String, dynamic> profile = {
        'phone_number': phone,
        'latitude': lattitude,
        'longitude': longitude,
        'profile_pic':
            "https://4fd81aa6.ngrok.io" + uploadedData['profile_pic'],
        'bio': bio,
        "rating": 0.0,
        "pricing": price,
        "is_tourist": false
        //'location': location
      };
      final Map<String, dynamic> authData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': username,
        'password': password,
        'guideprofile': profile,
      };

      await http.post(
        'https://4fd81aa6.ngrok.io/api/accounts/guide/signup/',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      ).then((http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print(response.statusCode);
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw responseData;
        } else {
          hasError = false;
        }
      });
      return !hasError;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> touristsignUp(
      {String firstName,
      String lastName,
      String email,
      String username,
      String password,
      String phone,
      String bio,
      File image}) async {
    bool hasError = true;
    try {
      final uploadedData = await uploadImage(image);
      final Map<String, dynamic> profile = {
        'phone_number': phone,
        'profile_pic':
            "https://4fd81aa6.ngrok.io/" + uploadedData['profile_pic'],
        'bio': bio,
        "is_tourist": true
      };
      final Map<String, dynamic> authData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': username,
        'password': password,
        'touristprofile': profile,
      };

      await http.post(
        'https://4fd81aa6.ngrok.io/api/accounts/tourist/signup/',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      ).then((http.Response response) {
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw response.body;
        } else {
          hasError = false;
        }
      });
      return !hasError;
    } catch (e) {
      throw e.toString();
    }
  }
}
