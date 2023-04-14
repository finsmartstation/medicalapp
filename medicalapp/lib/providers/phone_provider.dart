import 'package:flutter/material.dart';


class PhoneProvider with ChangeNotifier {
  String _phone = '';
  String _countryCode = '';
  String _type = '';
  String _a_id = '';
  String _a_name = '';
  bool? _presented;
  bool? _isFinished;
  String get phone => _phone;
  String get countryCode => _countryCode;
  String get type => _type;
  String get a_id => _a_id;
  String get a_name => _a_name;
  bool? get presented => _presented;
  bool? get isFinished => _isFinished;

  void phoneNumber(String phn, String code, String typ) {
    _phone = phn;
    _countryCode = code;
    _type = typ;
    notifyListeners();
  }

  void isValid(bool ok) {
    _presented = ok;
    notifyListeners();
  }

  void isCompleted(bool val) {
    _isFinished = val;
    notifyListeners();
  }

  void getAcessId(String id, String name) {
    _a_id = id;
    _a_name = name;
    notifyListeners();
  }

  
}
