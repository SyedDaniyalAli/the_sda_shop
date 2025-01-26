import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return '';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    //for runtime const we use final
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDeoNqfW-pHVua6EQu1doK1wh-d2tZ-xSc';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
    } catch (exceptionMessage) {
      throw exceptionMessage;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = '';
    _expiryDate = DateTime.now();
    _userId = '';
    _authTimer.cancel();
    _authTimer = Timer(Duration.zero, () {});
    notifyListeners();
  }

  void _autoLogout() {
    _authTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
