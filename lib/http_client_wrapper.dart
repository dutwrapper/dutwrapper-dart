import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClientResponse {
  final String host;
  final Map<String, String>? setHeaders;
  final int? statusCode;
  final String? body;
  final Object? ex;

  const HttpClientResponse({
    required this.host,
    this.statusCode,
    this.body,
    this.setHeaders,
    this.ex,
  });

  bool get isSuccessfulStatusCode {
    if (statusCode == null) {
      return false;
    }
    if (statusCode! >= 200 && statusCode! < 300) {
      return true;
    }
    return false;
  }

  void ensureSuccessfulStatusCode() {
    // If status returned with code in range 200-299, just end here.
    if (isSuccessfulStatusCode) {
      return;
    }
    // If have exception -> Request is not successful. Just throw them.
    else if (ex != null) {
      throw Exception("We can't connect with this server. "
          "Make sure you have entered address correctly, "
          "or check your internet connection."
          "\n\nException: $ex}");
    }
    // If no statusCode (null) -> Request is not successful. Just throw them.
    else if (statusCode == null) {
      throw Exception("We can't connect with this server. "
          "Make sure you have entered address correctly, "
          "or check your internet connection.");
    }
    // Throw otherwise
    else {
      throw Exception("$host has returned with code $statusCode");
    }
  }
}

class HttpClientWrapper {
  static Future<HttpClientResponse> get({
    required Uri uri,
    Map<String, String>? headers,
    int timeout = 60,
  }) async {
    try {
      final response = await http.get(uri, headers: headers).timeout(Duration(seconds: timeout));

      return HttpClientResponse(
        host: '${uri.scheme}://${uri.host}',
        statusCode: response.statusCode,
        body: response.body,
        setHeaders: Map.from(response.headers),
      );
    } on Exception catch (ex) {
      return HttpClientResponse(host: '${uri.scheme}://${uri.host}', ex: ex);
    }
  }

  static Future<HttpClientResponse> post({
    required Uri uri,
    Map<String, String>? postData,
    Map<String, String>? headers,
    int timeout = 60,
  }) async {
    try {
      final response = await http
          .post(
            uri,
            headers: headers,
            encoding: Encoding.getByName('utf-8'),
            body: postData,
          )
          .timeout(Duration(seconds: timeout));

      return HttpClientResponse(
        host: '${uri.scheme}://${uri.host}',
        statusCode: response.statusCode,
        body: response.body,
        setHeaders: Map.from(response.headers),
      );
    } on Exception catch (ex) {
      return HttpClientResponse(host: '${uri.scheme}://${uri.host}', ex: ex);
    }
  }
}
