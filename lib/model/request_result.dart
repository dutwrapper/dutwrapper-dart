import 'enums.dart';

class RequestResult<T> {
  final RequestCode requestCode;
  final int statusCode;
  final String sessionId;
  final T? data;

  const RequestResult({
    this.requestCode = RequestCode.unknown,
    this.statusCode = 0,
    this.sessionId = '',
    this.data,
  });

  RequestResult<T> clone({
    RequestCode? requestCode,
    int? statusCode,
    String? sessionId,
    T? data,
  }) {
    return RequestResult<T>(
      requestCode: requestCode ?? this.requestCode,
      statusCode: statusCode ?? this.statusCode,
      sessionId: sessionId ?? this.sessionId,
      data: data ?? this.data,
    );
  }
}
