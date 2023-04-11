import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'dashboardModeal.dart';

Future<DashboardGetModel> dashboardData(
    user_id, access_token, family_member_id) async {
  String url = baseUrl + 'all_patient_details';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "family_member_id": family_member_id,
  };
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );

  print(respons);

  print(respons.body);
  if (respons.statusCode == 200) {
    print(respons.body);
    final data = DashboardGetModel.fromJson(jsonDecode(respons.body));
    print(data.patientDetails);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}

//dashboardSearch
Future<DashboardSearch> dashboard_search(user_id, access_token, search) async {
  String url = baseUrl + 'dashboard_search';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "search": search,
  };
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );

  print(respons);

  print(respons.body);
  if (respons.statusCode == 200) {
    print(respons.body);
    final data = DashboardSearch.fromJson(jsonDecode(respons.body));
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
