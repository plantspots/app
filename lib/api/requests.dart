import 'package:plantspots/utils/requests.dart';
import 'package:plantspots/utils/vars.dart';

Future<Map<String, dynamic>> createRequestAPI(String hash, String title, String description, int type, bool emailContact, bool phoneContact, List<String> images) async {
  return postData("${rootAPIURL}requests", { "hash": hash, "title": title, "description": description , "type": type , "email_contact": emailContact , "phone_contact": phoneContact, "images": images.join("*") });
}

Future<Map<String, dynamic>> updateRequestAPI(String hash, int id, String title, String description, int type, bool emailContact, bool phoneContact, List<String> images) async {
  return postData("${rootAPIURL}update-request", { "hash": hash, "id": id, "title": title, "description": description , "type": type , "email_contact": emailContact , "phone_contact": phoneContact, "images": images.join("*") });
}

Future<Map<String, dynamic>> closeRequestAPI(String hash, int id) async {
  return postData("${rootAPIURL}close-request", { "hash": hash, "id": id });
}

Future<List<dynamic>> getRequestsAPI(String hash) async {
  return getListData(rootAPIDomain, "${rootAPIPath}requests", { "hash": hash });
}

Future<Map<String, dynamic>> getRequestAPI(String hash, int id) async {
  return getData(rootAPIDomain, "${rootAPIPath}get-request", { "hash": hash, "id": id.toString() });
}