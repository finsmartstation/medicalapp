import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientDetailsProvider with ChangeNotifier {
  String? Profile_path;
  String? full_profile_link;
  String? gender;
  String? lat;
  String? long;
  String bloodGroup = '';
  String? access_token;
  String? uId;
  TextEditingController dateOfBirthCondroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailCondroller = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController addresController = TextEditingController();

  void newUserProfileFile(
      ProfilePath, fullProfileLink, namee, emaile, genderr, latt, longg) {
    Profile_path = ProfilePath;
    full_profile_link = fullProfileLink;
    nameController.text = namee;
    emailCondroller.text = emaile;
    gender = genderr;

    lat = latt;
    notifyListeners();
  }

  void sharePrefSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isLogin', "patient");
    if (nameController.text.isNotEmpty) {
      prefs.setString('userName', nameController.text.toString());
    }
    if (emailCondroller.text.isNotEmpty) {
      prefs.setString('email', emailCondroller.text.toString());
    }
    if (Profile_path!.isNotEmpty) {
      prefs.setString('profilePicturePath', Profile_path.toString());
    }
    if (addresController.text.isNotEmpty) {
      prefs.setString('addres', addresController.text.toString());
    }

    if (full_profile_link!.isNotEmpty) {
      prefs.setString('profilePicture', full_profile_link.toString());
    }
    if (lat!.isNotEmpty) {
      prefs.setString('latitude', lat.toString());
    }
    if (long!.isNotEmpty) {
      prefs.setString('longitude', long.toString());
    }
    if (gender!.isNotEmpty) {
      prefs.setString('gender', gender.toString());
    }
    if (heightController.text.isNotEmpty) {
      prefs.setString('hight', heightController.text);
    }
    if (weightController.text.isNotEmpty) {
      prefs.setString('weight', weightController.text);
    }
    if (bloodGroup.isNotEmpty) {
      prefs.setString('blood', bloodGroup.toString());
    }

    print("profile path =============");
    print(prefs.getString('profilePicture'));
    notifyListeners();
  }

  Future<void> getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('userName').toString();
    emailCondroller.text = prefs.getString('email').toString();
    Profile_path = prefs.getString('profilePicturePath').toString();
    full_profile_link = prefs.getString('profilePicture').toString();
    lat = prefs.getString('latitude').toString();
    long = prefs.getString('longitude').toString();
    access_token = prefs.getString('accessToken').toString();
    uId = prefs.getString('userId').toString();
    gender = prefs.getString('gender').toString();
    notifyListeners();
  }

  void editProfile(ProfilePathh, fullProfileLink, namee, emaile, dob, bloodd,
      hightt, weightt, genderr, addres) {
    Profile_path = ProfilePathh;
    full_profile_link = fullProfileLink;
    nameController.text = namee;
    emailCondroller.text = emaile;
    dateOfBirthCondroller.text = dob;
    bloodGroup = bloodd;
    heightController.text = hightt;
    weightController.text = weightt;
    gender = genderr;
    addresController.text = addres;
    sharePrefSave();
    notifyListeners();
  }

  void saveFilePath(fullProfileLink) {
    print("object");
    full_profile_link = fullProfileLink;
    notifyListeners();
  }
}
