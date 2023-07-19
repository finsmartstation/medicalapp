import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../utility/constants.dart';
import 'dashboardModeal.dart';

Future<DashboardGetModel> dashboardData(
    userId, accessToken, familyMemberId) async {
  String url = '${baseUrl}all_patient_details';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "family_member_id": familyMemberId,
  };
  log(obj.toString());
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );

  log(respons.body);
  if (respons.statusCode == 200) {
    log(respons.body);
    final data = DashboardGetModel.fromJson(jsonDecode(respons.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

//dashboardSearch
Future<DashboardSearch> dashboard_search(userId, accessToken, search) async {
  String url = '${baseUrl}dashboard_search';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "search": search,
  };
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );

  log(respons.body);
  if (respons.statusCode == 200) {
    log(respons.body);
    final data = DashboardSearch.fromJson(jsonDecode(respons.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
