class UMEErrorData {
  UMEErrorData({
    Object? error,
    StackTrace? trace,
    int? startTimeMilliseconds,
  })  : error = error,
        trace = trace,
        startTimeMilliseconds =
            startTimeMilliseconds ?? DateTime.now().millisecondsSinceEpoch;

  Object? error;

  StackTrace? trace;

  int startTimeMilliseconds;
}
