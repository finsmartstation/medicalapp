import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'Modeal.dart';

Future<ListAllDoctors> listDoctor(
    userId, accessToken, search, familyMemberId) async {
  String url = '${baseUrl}list_all_doctors_filter';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "search": search,
    "family_member_id": familyMemberId
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
    userId, accessToken, familyMemberId, doctorId) async {
  String url = '${baseUrl}add_favourite_doctor';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "family_member_id": familyMemberId,
    "doctor_id": doctorId,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

//remove favorite doctor
Future<http.Response> removeFavoriteDoctor(
    userId, accessToken, familyMemberId, doctorId) async {
  String url = '${baseUrl}delete_favourite_doctor';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "family_member_id": familyMemberId,
    "doctor_id": doctorId,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

//doctor profile
Future<DoctorProfileDetails> doctor_profile_details(
    userId, accessToken, doctorId, familyMemberId) async {
  String url = '${baseUrl}doctor_profile_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "doctor_id": doctorId,
    "family_member_id": familyMemberId
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
    userId, accessToken) async {
  String url = '${baseUrl}delete_family_doctor';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
  };
  print("obj---$obj");
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}


  //add family doctor
  Future<http.Response> addFamilyDoctor(
       userId,  accessToken,  DoctorId) async {
    String url = '${baseUrl}add_family_doctor';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "family_doctor_id": DoctorId,
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }
