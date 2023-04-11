import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medicalapp/screens/SosScreen.dart/sosModeal.dart';

import '../../utility/constants.dart';

Future<http.Response> add_emergency_contact(
  user_id,
  access_token,
  name,
  mobile,
  relation,
) async {
  String url = baseUrl + 'add_emergency_contact';
  var obj = {
    'user_id': user_id,
    'access_token': access_token,
    'name': name,
    'mobile': mobile,
    'relation': relation,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}

Future<ListEmergencyContact> list_emergency_contact(
    user_id, access_token) async {
  String url = baseUrl + 'list_emergency_contact';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  if (response.statusCode == 200) {
    final Data = ListEmergencyContact.fromJson(jsonDecode(response.body));
    return Data;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<http.Response> delete_emergency_contact(
  user_id,
  access_token,
  id,
) async {
  String url = baseUrl + 'delete_emergency_contact';
  var obj = {
    'user_id': user_id,
    'access_token': access_token,
    'id': id,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}
