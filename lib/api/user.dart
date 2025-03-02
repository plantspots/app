import 'package:plantspots/utils/requests.dart';
import 'package:plantspots/utils/vars.dart';

Future<Map<String, dynamic>> loginAPI(String username, String password) async {
  return postData("${rootAPIURL}login", { "username": username, "password": password });
}

Future<Map<String, dynamic>> createAccountAPI(String username, String email, String phone, String password) async {
  return postData("${rootAPIURL}create-account", { "username": username, "email": email, "phone": phone , "password": password});
}