import 'dart:convert';

import 'package:my_app/dB/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

converToJson(response) {
  try {
    return jsonDecode(utf8.decode(response.responseBody));
  } catch (err) {
    return '';
  }
}

Future get_store_id() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id').toString();
}

Future get_access_token() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token').toString();
}

Future login_state() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('login').toString();
}

Future get_refresh_token() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('refresh_token').toString();
}

Future refresh_token() async {
  final prefs = await SharedPreferences.getInstance();

  var resp = await http.post(Uri.parse(token_refresh_url),
      body: {'refresh_token': await get_refresh_token()});

  return prefs.getString('access_token').toString();
}
