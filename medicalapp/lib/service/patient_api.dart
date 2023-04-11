import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import '../screens/doctorList/Modeal.dart';
import '../utility/constants.dart';

class PatientApi {
  //list all hospital

  Future<Map<String, dynamic>> listHospital(user_id, access_token) async {
    String url = baseUrl + 'list_all_hospitals';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return {"data": data};
    } else {
      throw Exception('Failed to load users');
    }
  }

  //add_user_medical_history
  Future<http.Response> add_user_medical_history(
      user_id, access_token, description, file_path) async {
    String url = baseUrl + 'add_user_medical_history';
    var obj = {
      'user_id': user_id,
      'access_token': access_token,
      'description': description,
      'file_path': file_path,
    };
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }

  // //list_user_medical_history
  // Future<ReportList> list_user_medical_history(user_id, access_token) async {
  //   String url = baseUrl + 'list_user_medical_history';
  //   var obj = {
  //     "user_id": user_id,
  //     "access_token": access_token,
  //   };
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final Data = ReportList.fromJson(jsonDecode(response.body));
  //     return Data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  //list all doctor
  Future<ListAllDoctors> listDoctor(user_id, access_token) async {
    String url = baseUrl + 'list_all_doctors';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    if (response.statusCode == 200) {
      final data = ListAllDoctors.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load users');
    }
  }

  // //list favourite doctor
  // Future<ShowFavouriteDoctors> listFavouriteDoctor(userId, access_token) async {
  //   String url = baseUrl + 'show_favourite_doctors';
  //   var obj = {"user_id": userId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = ShowFavouriteDoctors.fromJson(jsonDecode(response.body));
  //     //print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  // //list family doctor
  // Future<ShowFamilyDoctor> listFamilyDoctor(userId, access_token) async {
  //   String url = baseUrl + 'show_family_doctor';
  //   var obj = {"user_id": userId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = ShowFamilyDoctor.fromJson(jsonDecode(response.body));
  //     //print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  //doctor available slot
  Future<Map<String, dynamic>> doctorAvailableSlot(
      String userId, String access_token, String doctorId) async {
    String url = baseUrl + 'doctor_available_slots';
    var obj = {
      "user_id": userId,
      "access_token": access_token,
      "doctor_id": doctorId
    };
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //print(data);
      return {"data": data};
    } else {
      throw Exception('Failed to load users');
    }
  }

  //add user symtoms
  Future<http.Response> addSymptoms(String userId, String access_token,
      String familyMemberId, String symptoms) async {
    String url = baseUrl + 'add_user_symptoms';
    var obj = {
      "user_id": userId,
      "access_token": access_token,
      "family_member_id": familyMemberId,
      "symptoms": symptoms
    };
    print(obj);
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }

  //add_family_members
  Future<http.Response> add_family_members(user_id, access_token, gender, name,
      relation, dob, blood_group, height, weight, profile_pic) async {
    String url = baseUrl + 'add_family_members';
    var obj = {
      "user_id": user_id.toString(),
      "access_token": access_token.toString(),
      "gender": gender,
      "name": name,
      "relation": relation,
      "dob": dob,
      "blood_group": blood_group,
      "height": height,
      "weight": weight,
      "profile_pic": profile_pic
    };
    var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
    return response;
  }
  // //get_family_members

  // Future<GetFamilyMembers> get_family_members(user_id, access_token) async {
  //   String url = baseUrl + 'get_family_members';
  //   var obj = {
  //     "user_id": user_id.toString(),
  //     "access_token": access_token.toString(),
  //   };
  //   var respons = await http.post(Uri.parse(url), body: obj);
  //   return GetFamilyMembers.fromJson(jsonDecode(respons.body));
  // }

  //list_all_bannerlist
  // Future<ListAllBannerlist> list_all_bannerlist(user_id, access_token) async {
  //   String url = baseUrl + 'list_all_bannerlist';
  //   var obj = {
  //     "user_id": user_id,
  //     "access_token": access_token,
  //   };
  //   var respons = await http.post(Uri.parse(url), body:obj);
  //   // print(respons);

  //   // print(respons.body);
  //   if (respons.statusCode == 200) {
  //     final data = ListAllBannerlist.fromJson(jsonDecode(respons.body));
  //     print(data.data[0].image.toString());
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  //book doctor slot
  Future<http.Response> bookDoctorSlot(
      String userId,
      String access_token,
      String doctor_id,
      String book_slot_id,
      String booking_id,
      String family_member_id,
      String sick_notes) async {
    String url = baseUrl + 'book_doctor_slot';
    var obj = {
      "user_id": userId,
      "access_token": access_token,
      "doctor_id": doctor_id,
      "book_slot_id": book_slot_id,
      "booking_id": booking_id,
      "family_memberid": family_member_id,
      "sick_notes": sick_notes,
    };
    print(obj);
    var response = await http.post(Uri.parse(url), body: obj);
    print(jsonDecode(response.body));
    return response;
  }
}
