import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'Modeal.dart';

Future<ListAllDoctors> listDoctor(
    user_id, access_token, search, family_member_id) async {
  String url = baseUrl + 'list_all_doctors_filter';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "search": search,
    "family_member_id": family_member_id
  };

  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("success");
  print(obj);
  if (response.statusCode == 200) {
    final data = ListAllDoctors.fromJson(jsonDecode(response.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

//add favorite doctor
Future<http.Response> addFavoriteDoctor(
    userId, access_token, familyMemberId, doctorId) async {
  String url = baseUrl + 'add_favourite_doctor';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
    "family_member_id": familyMemberId,
    "doctor_id": doctorId,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

//remove favorite doctor
Future<http.Response> removeFavoriteDoctor(
    userId, access_token, familyMemberId, doctorId) async {
  String url = baseUrl + 'delete_favourite_doctor';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
    "family_member_id": familyMemberId,
    "doctor_id": doctorId,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

//doctor profile
Future<DoctorProfileDetails> doctor_profile_details(
    user_id, access_token, doctor_id, family_member_id) async {
  String url = baseUrl + 'doctor_profile_details';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "doctor_id": doctor_id,
    "family_member_id": family_member_id
  };

  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("success");
  print(obj);
  if (response.statusCode == 200) {
    final data = DoctorProfileDetails.fromJson(jsonDecode(response.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

//remove family doctor
Future<http.Response> delete_family_doctor(
    userId, access_token) async {
  String url = baseUrl + 'delete_family_doctor';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}


  //add family doctor
  Future<http.Response> addFamilyDoctor(
       userId,  access_token,  DoctorId) async {
    String url = baseUrl + 'add_family_doctor';
    var obj = {
      "user_id": userId,
      "access_token": access_token,
      "family_doctor_id": DoctorId,
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }
