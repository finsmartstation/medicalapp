import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'model.dart';

Future<http.Response> add_case_history(user_id, access_token, description,
    file_path, family_member_id, file_type, date_time) async {
  String url = baseUrl + 'add_case_history';
  var obj = {
    'user_id': user_id,
    'access_token': access_token,
    'document_name': description,
    'file_path': file_path,
    'family_member_id': family_member_id,
    'file_type': file_type,
    'date_time': date_time,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<ListCaseHistory> list_case_history(
    user_id, access_token, family_member_id) async {
  String url = baseUrl + 'list_case_history';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    'family_member_id': family_member_id
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  if (response.statusCode == 200) {
    final Data = ListCaseHistory.fromJson(jsonDecode(response.body));
    return Data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<http.Response> delete_medical_history(user_id, access_token, id) async {
  String url = baseUrl + 'delete_medical_history';
  var obj = {"user_id": user_id, "access_token": access_token, 'id': id};
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}
