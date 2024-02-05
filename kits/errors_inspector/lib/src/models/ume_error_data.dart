class UMEErrorData {
  UMEErrorData({
    dynamic data,
    int? startTimeMilliseconds,
  }) : startTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

  dynamic data;

  int startTimeMilliseconds;
}
