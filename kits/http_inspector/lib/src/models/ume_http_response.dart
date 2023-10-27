import 'package:http_inspector/src/models/ume_http_request.dart';

class UMEHttpResponse {
  final UMEHttpRequest requestOptions;
  final DateTime startTime;
  final DateTime endTime;
  final int? statusCode;
  final dynamic data;
  final Map<String, String> headers;

  const UMEHttpResponse({
    required this.data,
    required this.statusCode,
    required this.requestOptions,
    required this.startTime,
    required this.endTime,
    required this.headers,
  });
}
