import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'model.dart';

Future<http.Response> add_case_history(userId, accessToken, description,
    filePath, familyMemberId, fileType, dateTime) async {
  String url = '${baseUrl}add_case_history';
  var obj = {
    'user_id': userId,
    'access_token': accessToken,
    'document_name': description,
    'file_path': filePath,
    'family_member_id': familyMemberId,
    'file_type': fileType,
    'date_time': dateTime,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<ListCaseHistory> list_case_history(
    userId, accessToken, familyMemberId) async {
  String url = '${baseUrl}list_case_history';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    'family_member_id': familyMemberId
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  if (response.statusCode == 200) {
    final Data = ListCaseHistory.fromJson(jsonDecode(response.body));
    return Data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<http.Response> delete_medical_history(userId, accessToken, id) async {
  String url = '${baseUrl}delete_medical_history';
  var obj = {"user_id": userId, "access_token": accessToken, 'id': id};
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}
