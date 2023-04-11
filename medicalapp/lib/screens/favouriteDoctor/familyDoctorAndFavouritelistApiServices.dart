import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utility/constants.dart';
import 'listfamilymodel.dart';

Future<ListFavouriteFamilyDoctors> listFamilyAndFavoriteDoctors(
    user_id, access_token, family_member_id) async {
  String url = baseUrl + 'list_favourite_family_doctors';
  var obj = {
    "user_id": user_id,
    "access_token": access_token,
    "family_member_id": family_member_id,
  };
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );
  if (respons.statusCode == 200) {
    final data = ListFavouriteFamilyDoctors.fromJson(jsonDecode(respons.body));
    print(data.familyDoctor);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
