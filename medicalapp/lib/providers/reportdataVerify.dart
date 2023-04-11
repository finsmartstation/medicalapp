import 'package:flutter/material.dart';

class ReportDataVerify with ChangeNotifier {
  String documentVerify = "";
  String fileVerify = "";
  String dates = "";
  void documentName() {
    documentVerify = "Required Document Details";
    notifyListeners();
  }

  void date() {
    dates = "Required Date";
    notifyListeners();
  }

  void filePdf() {
    fileVerify = "Required Upload File";
    notifyListeners();
  }
}
