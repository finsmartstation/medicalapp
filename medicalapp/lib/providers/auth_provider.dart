import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _u_id = '';
  String _otp = '';
  String _access_token = '';
  bool isLoading = false;

  String get u_id => _u_id;
  String get otp => _otp;
  String get access_token => _access_token;

  void getDetails(String userId, String Otp, String aToken) {
    _u_id = userId;
    _otp = Otp;
    _access_token = aToken;
    notifyListeners();
  }

  void clearData() {
    _u_id = '';
    _otp = '';
    _access_token = '';
    notifyListeners();
  }
}
