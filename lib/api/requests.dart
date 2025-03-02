import 'package:plantspots/utils/requests.dart';
import 'package:plantspots/utils/vars.dart';

Future<Map<String, dynamic>> createRequestAPI(String title, String description, int type, bool emailContact, bool phoneContact, List<String> images) async {
  return postData("${rootAPIURL}requests", { "title": title, "description": description , "type": type , "email_contact": emailContact , "phone_contact": phoneContact, "images": images.join("*") });
}

Future<List<dynamic>> getRequestsAPI(String hash) async {
  return getListData(rootAPIDomain, "${rootAPIPath}requests", { "hash": hash });
}