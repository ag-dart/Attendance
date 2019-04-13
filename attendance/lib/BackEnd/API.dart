import 'package:attendance/BackEnd/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class API {

  static const String baseUrl = "https://attendance-app-api.herokuapp.com/";
  http.Client client;

  API() {
    client = http.Client();
  }

  Future<String> setUserInfo(User user) async {
    Map<String, String> headers =  Map<String, String>();
    headers["x-token"] = await user.token();
    headers['Content-Type'] = 'application/json';
    final String url = "${baseUrl}verify";
    final http.Request request = http.Request('POST', Uri.parse(url))
    ..headers.addAll(headers)
    ..body = user.requestBody()
    ..followRedirects = false;
    http.StreamedResponse response = await client.send(request);
    final int statusCode = response.statusCode;
    String responseData = await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception("status code is not 200\n" + responseData);
  }
  
}