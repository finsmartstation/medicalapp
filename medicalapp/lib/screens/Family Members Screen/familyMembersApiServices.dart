import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'getFamilyMembersDetailsModel.dart';

//get_family_members

Future<GetFamilyMembers> get_family_members(userId, accessToken) async {
  String url = '${baseUrl}get_family_members';
  var obj = {
    "user_id": userId.toString(),
    "access_token": accessToken.toString(),
  };
  var respons = await http.post(Uri.parse(url), body: obj);
  return GetFamilyMembers.fromJson(jsonDecode(respons.body));
}

//delete family member
Future<http.Response> delete_family_member(
    userId, accessToken, familyMemberId) async {
  String url = '${baseUrl}delete_family_member';
  var obj = {
    'user_id': userId,
    'access_token': accessToken,
    'id': familyMemberId,
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  return response;
}
