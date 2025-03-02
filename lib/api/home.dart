import 'package:plantspots/utils/requests.dart';
import 'package:plantspots/utils/vars.dart';

Future<List<dynamic>> homeAPI(String hash) async {
  return getListData(rootAPIDomain, "${rootAPIPath}home", { "hash": hash });
}