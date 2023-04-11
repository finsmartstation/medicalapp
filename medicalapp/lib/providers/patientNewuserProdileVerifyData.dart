import 'package:flutter/cupertino.dart';

class VerifyNewUserProfileData with ChangeNotifier {
  String verifyname = "";
  String verifyemail = "";
  String verifyprofile = "";
  String verifygender="";
  void nameRequired() {
    verifyname = "Required Name";
    notifyListeners();
  }

  void emailRequired() {
    verifyemail = "Required Email";
    notifyListeners();
  }

  void profileRequired() {
    verifyprofile = "Required Profile";
    notifyListeners();
  }
  void genderRequird(){
    verifygender="Required Gender";
    notifyListeners();
  }
}
