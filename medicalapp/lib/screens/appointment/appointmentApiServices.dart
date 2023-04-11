//patient_book_slot_history
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:medicalapp/screens/appointment/modealClass.dart';

import '../../utility/constants.dart';
import 'appointmentDetailsModeal.dart';

Future<PatientBookSlotHistory> patientBookSlotHistory(
    userId, access_token, family_member_id) async {
  String url = baseUrl + 'patient_book_slot_history';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
    "family_member_id": family_member_id
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("success");
  print(obj);
  if (response.statusCode == 200) {
    final data = PatientBookSlotHistory.fromJson(json.decode(response.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

//doctor_available_slot_details
Future<DoctorAvailableSlotDetails> doctor_available_slot_details(
    userId, access_token, doctor_id, date_id) async {
  String url = baseUrl + 'doctor_available_slot_details';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
    "doctor_id": doctor_id,
    "date_id": date_id,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("success");
  print(obj);
  if (response.statusCode == 200) {
    final data =
        DoctorAvailableSlotDetails.fromJson(json.decode(response.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<http.Response> slot_booking(user_id, access_token, doctor_id,
    family_member_id, book_slot_id, sick_notes, visit_type) async {
  String url = baseUrl + 'slot_booking';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    'doctor_id': doctor_id,
    'family_member_id': family_member_id,
    'book_slot_id': book_slot_id,
    'sick_notes': sick_notes,
    'visit_type': visit_type
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<PatientAppoinmentDetails> patient_appoinment_details(
    userId, access_token, slot_id) async {
  String url = baseUrl + 'patient_appoinment_details';
  var obj = {
    "user_id": userId,
    "access_token": access_token,
    "slot_id": slot_id,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("success");
  print(obj);
  if (response.statusCode == 200) {
    final data = PatientAppoinmentDetails.fromJson(json.decode(response.body));
    print(response.body);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
