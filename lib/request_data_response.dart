import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestDataResponse {
  final int? statusCode;
  final Map<String, String>? setHeaders;
  final String? webContent;
  final Exception? ex;

  RequestDataResponse(
      {required this.statusCode,
      required this.setHeaders,
      required this.webContent,
      this.ex});

  static Future<RequestDataResponse> getAsync({
    required String url,
    Map<String, String>? headers,
    int timeout = 60,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeout));

      return RequestDataResponse(
        statusCode: response.statusCode,
        setHeaders: Map.from(response.headers),
        webContent: response.body,
      );
    } on Exception catch (ex) {
      return RequestDataResponse(
        statusCode: null,
        setHeaders: null,
        webContent: null,
        ex: ex,
      );
    }
  }

  static Future<RequestDataResponse> postAsync({
    required String url,
    Map<String, String>? postData,
    Map<String, String>? headers,
    int timeout = 60,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            encoding: Encoding.getByName('utf-8'),
            body: postData,
          )
          .timeout(Duration(seconds: timeout));

      return RequestDataResponse(
        statusCode: response.statusCode,
        setHeaders: Map.from(response.headers),
        webContent: response.body,
      );
    } on Exception catch (ex) {
      return RequestDataResponse(
        statusCode: null,
        setHeaders: null,
        webContent: null,
        ex: ex,
      );
    }
  }
}
