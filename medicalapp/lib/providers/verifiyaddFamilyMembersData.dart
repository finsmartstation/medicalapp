import 'package:flutter/material.dart';

class VerifyAddFamilyMembersData with ChangeNotifier {
  String verifyDob = "";
  String verifyName = "";
  String verifyEmail = "";
  String verifyRelation = "";
  String verifyGender = "";
  String verifyprofilePath = "";
  String verifyBlood = "";
  String verifyHight = "";
  String verifyaddres = '';
  String verifiyWeight = "";
  void dobRequired() {
    verifyDob = "Required Date Of Birth";
    notifyListeners();
  }

  void addresRequired() {
    verifyaddres = "Required Address";
    notifyListeners();
  }

  void nameRequired() {
    verifyName = "Required Name";
    notifyListeners();
  }

  void emailRequired() {
    verifyEmail = "Required Email";
    notifyListeners();
  }

  void relationRequired() {
    verifyRelation = "Required Relation";
    notifyListeners();
  }

  void genderRequired() {
    verifyGender = "Required Gender";
    notifyListeners();
  }

  void profilePath() {
    verifyprofilePath = "Required Profile ";
    notifyListeners();
  }

  void blood() {
    verifyBlood = "Required Blood Group";
    notifyListeners();
  }

  void hight() {
    verifyHight = "Required Height";
    notifyListeners();
  }

  void weight() {
    verifiyWeight = "Required Weight";
    notifyListeners();
  }
}
