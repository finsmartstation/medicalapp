//patient_book_slot_history
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medicalapp/screens/appointment/modealClass.dart';

import '../../utility/constants.dart';
import 'appointmentDetailsModeal.dart';

Future<PatientBookSlotHistory> patientBookSlotHistory(
    userId, accessToken, familyMemberId) async {
  String url = '${baseUrl}patient_book_slot_history';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "family_member_id": familyMemberId
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("=====success=====");
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
    userId, accessToken, doctorId, dateId) async {
  String url = '${baseUrl}doctor_available_slot_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "doctor_id": doctorId,
    "date_id": dateId,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print(obj);
  print("---------success-----------");
  print(json.decode(response.body));
  if (response.statusCode == 200) {
    print(response.body);

    final data =
        DoctorAvailableSlotDetails.fromJson(json.decode(response.body));
    print(data.data.slots[0].appoinmentType);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<http.Response> slot_booking(userId, accessToken, doctorId,
    familyMemberId, bookSlotId, sickNotes, visitType) async {
  String url = '${baseUrl}slot_booking';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    'doctor_id': doctorId,
    'family_member_id': familyMemberId,
    'book_slot_id': bookSlotId,
    'sick_notes': sickNotes,
    'visit_type': visitType
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<http.Response> send_call_alert(
  userId,
  accessToken,
  doctorId,
  slot_id,
) async {
  String url = '${baseUrl}send_call_alert';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    'receiver_id': doctorId,
    'user_type': 'Patient',
    'slot_id': slot_id,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<PatientAppoinmentDetails> patient_appoinment_details(
    userId, accessToken, slotId) async {
  String url = '${baseUrl}patient_appoinment_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "slot_id": slotId,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  print("+++++++success+++++++");
  print(obj);
  if (response.statusCode == 200) {
    final data = PatientAppoinmentDetails.fromJson(json.decode(response.body));
    print(response.body);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
