import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class httpUtils {
  static Future<http.Response> get(String url) async {
    final response =  await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    return response;
  }

  static Future<http.Response> post(
      String url, String? body, Map<String, String>? headers) {
    Map<String, String> map = {};
    map.addAll({"Content-Type": "application/json; charset=utf-8"});
    if (headers != null) {
      map.addAll(headers);
    }
    final response =  http.post(
      Uri.parse(url),
      headers: map,
      body: body,
    );
    return response;
  }
}
