import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';

//fill_patient_profile
Future<http.Response> fill_patient_profile(userId, accessToken, gender, email,
    name, dob, bloodGroup, height, weight, profilePicPath) async {
  String url = '${baseUrl}fill_patient_profile';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "gender": gender,
    "email": email,
    "name": name,
    "dob": dob.toString(),
    "blood_group": bloodGroup,
    "height": height,
    "weight": weight,
    "profile_pic_path": profilePicPath
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}

//edit_patient_details

Future<http.Response> edit_patient_details(
    userId,
    accessToken,
    familyMemberId,
    gender,
    email,
    name,
    dob,
    bloodGroup,
    height,
    weight,
    relation,
    profilePicPath) async {
  String url = '${baseUrl}edit_patient_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "family_member_id": familyMemberId,
    "gender": gender,
    "email": email,
    "name": name,
    "dob": dob.toString(),
    "blood_group": bloodGroup,
    "height": height,
    "weight": weight,
    "relation": relation,
    "profile_pic_path": profilePicPath
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}

//fill_patient_basic_profile
Future<http.Response> patient_profile_details(
    userId, accessToken, gender, email, name,profilePicPath,longitude,latitude) async {
  String url = '${baseUrl}patient_profile_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "gender": gender,
    "email": email,
    "name": name,
    "profile_pic": profilePicPath,
    "longitude":longitude,
    "latitude":latitude
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  return response;
}
