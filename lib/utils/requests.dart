import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getData(String domain, String path, Map<String, dynamic> data) async {
  // print("a");
  final response = await http.get(
    Uri.https(domain, path, data),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    );
    // log(response.body);
  final res = jsonDecode(response.body) as Map<String, dynamic>;
  res["status_code"] = response.statusCode;
  return res;
}

Future<List<dynamic>> getListData(String domain, String path, Map<String, dynamic> data) async {
  final response = await http.get(
    Uri.https(domain, path, data),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    );
    // print(response.body);
  final res = jsonDecode(response.body) as List<dynamic>;
  // res.insert(0, element) response.statusCode;
  return res;
}

Future<Map<String, dynamic>> postData(String url, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
    );
    // log(jsonEncode(data));
  final res = jsonDecode(response.body) as Map<String, dynamic>;
  res["status_code"] = response.statusCode;
  return res;
}