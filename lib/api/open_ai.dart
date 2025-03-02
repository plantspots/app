import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plantspots/utils/requests.dart';
import 'package:plantspots/utils/vars.dart';

Future<Map<String, dynamic>> getOpenAIKeyAPI(String hash) async {
  return getData(rootAPIDomain, "${rootAPIPath}openai", { "hash": hash });
}

Future<http.Response> sendMessageOpenAIAPI(List<Map<String, String>> messages, String openAIKey) {
  final uri = Uri.https("api.openai.com", "/v1/chat/completions");

  return http.post(
    uri,
    headers: <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $openAIKey"
    },
    body: jsonEncode({
      "model": "gpt-4o-mini",
      "messages": messages,
      "temperature": 1,
      "max_tokens": 4096,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    })
  );
}