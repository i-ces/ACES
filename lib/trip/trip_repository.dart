import 'dart:async';
import 'dart:io';
import 'package:ghumnajaam/account_bloc/account_model.dart';
import 'package:ghumnajaam/trip/index.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TripRepository {
  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse('https://b5d3b73b.ngrok.io/api/trip/image/'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['image'] = Uri.encodeComponent(imagePath);
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
      print(responseData);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> insertTrip(
      {int day,
      String place,
      String placeId,
      double rating,
      String description,
      File images}) async {
    print("called");
    final uploadData = await uploadImage(images);
    print(uploadData);
    Map<String, dynamic> authData = {
      'days': day,
      'place': place,
      'placeId': placeId,
      'rating': rating,
      'description': description,
      'image': "https://b5d3b73b.ngrok.io" + uploadData['image']
    };
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;
    var encodedData = json.encode(authData);
    print(authData);
    await http.post("https://b5d3b73b.ngrok.io/api/trip/create/",
        body: encodedData,
        headers: {
          _headersKey: _headersValue,
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData);
    });
    return true;
  }

  Future<List<TripModel>> fetchTrips() async {
    List<TripModel> trips = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;

    await http.get("https://b5d3b73b.ngrok.io/api/trip/view/", headers: {
      _headersKey: _headersValue,
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData);

      jsonData.forEach((acc) {
        TripModel trip = TripModel(
            id: acc['id'],
            profilePic: acc['user']['profile_pic'],
            name: acc['user']['first_name'] + " " + acc['user']['last_name'],
            address: acc['place'],
            urls: acc['image'],
            rating: (acc['rating'] + 0.0),
            details: acc['description'],
            time: acc['created_at']);
        trips.add(trip);
      });
    });
    return trips;
  }

  Future<List<TripModel>> fetchReviews(int id) async {
    List<TripModel> trips = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;

    await http.get("https://b5d3b73b.ngrok.io/api/accounts/review/?guideid=$id",
        headers: {
          _headersKey: _headersValue,
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData);

      jsonData.forEach((acc) {
        TripModel trip = TripModel(
            id: acc['id'],
            name: acc['user']['first_name'] + " " + acc['user']['last_name'],
            rating: (acc['rating'] + 0.0),
            review: acc['review']);
        print(trip);
        trips.add(trip);
      });
    });
    return trips;
  }

  Future<List<TripModel>> fetchOtherTrips(int id) async {
    List<TripModel> trips = [];

    await http.get("https://b5d3b73b.ngrok.io/api/trip/userfeeds/?userid=$id",
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      jsonData.forEach((acc) {
        TripModel trip = TripModel(
            profilePic: acc['user']['profile_pic'],
            name: acc['user']['first_name'] + " " + acc['user']['last_name'],
            address: acc['place'],
            urls: acc['image'],
            rating: (acc['rating'] + 0.0),
            time: acc['created_at'],
            details: acc['description']);
        trips.add(trip);
      });
    });
    return trips;
  }

  Future<List<TripModel>> fetchfeedTrips(String placeId) async {
    List<TripModel> trips = [];

    await http
        .get(
      "https://b5d3b73b.ngrok.io/api/trip/placefeeds/?placeid=$placeId",
    )
        .then((http.Response response) {
      print(response.body);
      var jsonData = json.decode(response.body);
      print(jsonData);
      jsonData.forEach((acc) {
        TripModel trip = TripModel(
            name: acc['user']['first_name'] + " " + acc['user']['last_name'],
            address: acc['place'],
            urls: acc['image'],
            rating: (acc['rating'] + 0.0),
            time: acc['created_at'],
            details: acc['description']);
        trips.add(trip);
      });
    });
    return trips;
  }

  Future<List<AccountModel>> fetchPending() async {
    List<AccountModel> trips = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final bool flag = prefs.getBool('flag');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;

    await http.get("https://b5d3b73b.ngrok.io/api/hire/pending/", headers: {
      _headersKey: _headersValue,
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      flag == true
          ? jsonData.forEach((acc) {
              print(acc);
              AccountModel trip = AccountModel(
                  reqId: acc['id'],
                  message: acc['hiringdetail'],
                  id: acc['guide']['user']['id'],
                  email: acc['guide']['user']['email'],
                  firstName: acc['guide']['user']['first_name'],
                  lastName: acc['guide']['user']['last_name'],
                  username: acc['guide']['user']['username'],
                  profilepic: acc['guide']['profile_pic'],
                  lattitude: double.parse(acc['guide']['latitude']),
                  longitude: double.parse(acc['guide']['longitude']),
                  price: acc['guide']['pricing'].toString(),
                  phone: acc['guide']['phone_number'],
                  bio: acc['guide']['bio'],
                  rating: acc['guide']['rating']);
              trips.add(trip);
            })
          : jsonData.forEach((acc) {
              print("hi");
              AccountModel trip = AccountModel(
                  reqId: acc['id'],
                  message: acc['hiringdetail'],
                  id: acc['tourist']['user']['id'],
                  email: acc['tourist']['user']['email'],
                  firstName: acc['tourist']['user']['first_name'],
                  lastName: acc['tourist']['user']['last_name'],
                  username: acc['tourist']['user']['username'],
                  profilepic: acc['tourist']['profile_pic'],
                  phone: acc['tourist']['phone_number'],
                  bio: acc['tourist']['bio']);
              trips.add(trip);
            });
    });
    return trips;
  }

  Future<List<AccountModel>> fetchApproved() async {
    List<AccountModel> trips = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String _headersKey = "Authorization";
    String _headersValue = "Token " + token;
    final bool flag = prefs.getBool('flag');
    await http.get("https://b5d3b73b.ngrok.io/api/hire/approved/", headers: {
      _headersKey: _headersValue,
      'Content-Type': 'application/json'
    }).then((http.Response response) {
      var jsonData = json.decode(response.body);
      flag == true
          ? jsonData.forEach((acc) {
              AccountModel trip = AccountModel(
                  reqId: acc['id'],
                  message: acc['hiringdetail'],
                  id: acc['guide']['user']['id'],
                  email: acc['guide']['user']['email'],
                  firstName: acc['guide']['user']['first_name'],
                  lastName: acc['guide']['user']['last_name'],
                  username: acc['guide']['user']['username'],
                  profilepic: acc['guide']['profile_pic'],
                  lattitude: double.parse(acc['guide']['latitude']),
                  longitude: double.parse(acc['guide']['longitude']),
                  phone: acc['guide']['phone_number'],
                  bio: acc['guide']['bio'],
                  price: acc['guide']['pricing'].toString(),
                  rating: acc['guide']['rating']);
              trips.add(trip);
            })
          : jsonData.forEach((acc) {
              AccountModel trip = AccountModel(
                  reqId: acc['id'],
                  message: acc['hiringdetail'],
                  id: acc['tourist']['user']['id'],
                  email: acc['tourist']['user']['email'],
                  firstName: acc['tourist']['user']['first_name'],
                  lastName: acc['tourist']['user']['last_name'],
                  username: acc['tourist']['user']['username'],
                  profilepic: acc['tourist']['profile_pic'],
                  phone: acc['tourist']['phone_number'],
                  bio: acc['tourist']['bio']);
              trips.add(trip);
            });
    });
    return trips;
  }
}
