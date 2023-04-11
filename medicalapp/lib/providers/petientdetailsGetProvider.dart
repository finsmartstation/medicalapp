import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GetpetientDetails with ChangeNotifier {
  String username = "";
  String mobile = "";
  String email = "";
  String gender = "";
  String profile_pic = "";
  String blood_group = "";
  String height = "";
  String weight = "";
  String family_member_id = '';
  // //patient_details
  // Future<PatientDetailsGetModel> patient_details(user_id, access_token) async {
  //   String url = baseUrl + 'patient_details';
  //   var obj = {
  //     "user_id": user_id.toString(),
  //     "access_token": access_token.toString(),
  //   };
  //   var respons = await http.post(Uri.parse(url), body: obj);
  //   if (respons.statusCode == 200) {
  //     return PatientDetailsGetModel.fromJson(jsonDecode(respons.body));
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  fetchdata(user_id, access_token) async {
    // final Data =
    //     await patient_details(user_id, access_token).then((value) async {
    //   username = value.data.username.toString(); 
    //   mobile = value.data.mobile.toString();
    //   email = value.data.email.toString();
    //   gender = value.data.gender.toString();
    //   profile_pic = value.data.profilePic.toString();
    //   blood_group = value.data.bloodGroup.toString();
    //   height = value.data.height.toString();
    //   weight = value.data.weight.toString();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('userName', username.toString());
    //   prefs.setString('email', email.toString());
    //   prefs.setString('profilePicture', profile_pic.toString());
    //   prefs.setString('gender', gender.toString());
    //   prefs.setString('hight', height);
    //   prefs.setString('weight', weight);
    //   prefs.setString('blood', blood_group.toString());
    // });
    notifyListeners();
  }
}
