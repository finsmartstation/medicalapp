import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utility/constants.dart';
import 'consuiltedDoctorsDateListModel.dart';
import 'myReportsModeal.dart';

Future<ConsultedDoctorsList> consulted_doctors_list(
    user_id, access_token, family_member_id) async {
  String url = baseUrl + 'consulted_doctors_list';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    'family_member_id': family_member_id
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  if (response.statusCode == 200) {
    final Data = ConsultedDoctorsList.fromJson(jsonDecode(response.body));
    return Data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<ConsultedDoctorsDateList> consulted_doctors_date_list(
    user_id, access_token, family_member_id, doctor_id) async {
  String url = baseUrl + 'consulted_doctors_date_list';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "family_member_id": family_member_id,
    "doctor_id": doctor_id
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  if (response.statusCode == 200) {
    final Data = ConsultedDoctorsDateList.fromJson(jsonDecode(response.body));
    print(Data);
    return Data;
  } else {
    throw Exception('Failed to load users');
  }
}
