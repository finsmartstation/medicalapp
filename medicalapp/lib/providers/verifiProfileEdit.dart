import 'package:flutter/cupertino.dart';

class VerifyProfileEditData with ChangeNotifier {
  String verifyDob = "";
  String verifyWeight = "";
  String verifyHight = "";
  String verifyBlood="";
  void dobRequired() {
    verifyDob = "Required Date Of Birth";
    notifyListeners();
  }

  void hightRequired() {
    verifyHight = "Required Hight";
    notifyListeners();
  }

  void weightRequired() {
    verifyWeight = "Required Weight";
    notifyListeners();
  }
  void bloodRequird(){
    verifyBlood="Required Blood Group";
    notifyListeners();
  }
}
