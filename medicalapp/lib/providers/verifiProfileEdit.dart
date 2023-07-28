import 'package:flutter/cupertino.dart';

class VerifyProfileEditData with ChangeNotifier {
  String verifyDob = "";
  String verifyWeight = "";
  String verifyHight = "";
  String verifyBlood = "";
  String verifyAddress = '';
  void dobRequired() {
    verifyDob = "Required Date Of Birth";
    notifyListeners();
  }

  void hightRequired() {
    verifyHight = "Required Height";
    notifyListeners();
  }

  void weightRequired() {
    verifyWeight = "Required Weight";
    notifyListeners();
  }

  void bloodRequird() {
    verifyBlood = "Required Blood Group";
    notifyListeners();
  }

  void addressRequire() {
    verifyAddress = "Required address";
    notifyListeners();
  }
}
