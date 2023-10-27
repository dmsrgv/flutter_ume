class UMEHttpRequest {
  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final dynamic data;

  const UMEHttpRequest({
    required this.method,
    required this.uri,
    required this.headers,
    required this.data,
  });
}