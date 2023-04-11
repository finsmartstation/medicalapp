import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';

//fill_patient_profile
Future<http.Response> fill_patient_profile(user_id, access_token, gender, email,
    name, dob, blood_group, height, weight, profile_pic_path) async {
  String url = baseUrl + 'fill_patient_profile';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "gender": gender,
    "email": email,
    "name": name,
    "dob": dob.toString(),
    "blood_group": blood_group,
    "height": height,
    "weight": weight,
    "profile_pic_path": profile_pic_path
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}

//edit_patient_details

Future<http.Response> edit_patient_details(
    user_id,
    access_token,
    family_member_id,
    gender,
    email,
    name,
    dob,
    blood_group,
    height,
    weight,
    relation,
    profile_pic_path) async {
  String url = baseUrl + 'edit_patient_details';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "family_member_id": family_member_id,
    "gender": gender,
    "email": email,
    "name": name,
    "dob": dob.toString(),
    "blood_group": blood_group,
    "height": height,
    "weight": weight,
    "relation": relation,
    "profile_pic_path": profile_pic_path
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}

//fill_patient_basic_profile
Future<http.Response> patient_profile_details(
    user_id, access_token, gender, email, name,profile_pic_path) async {
  String url = baseUrl + 'patient_profile_details';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "gender": gender,
    "email": email,
    "name": name,
    "profile_pic": profile_pic_path
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}
