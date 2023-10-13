import 'dart:convert';

enum EventType {
  ecommerce,
  userProfile,
  custom,
}

class Event<T> {
  Event({
    this.data,
    this.eventType,
    int? startTimeMilliseconds,
    Map<String, dynamic>? payload,
  })  : payload = payload ?? <String, dynamic>{},
        startTimeMilliseconds = startTimeMilliseconds ?? 0;

  T? data;
  EventType? eventType;
  Map<String, dynamic> payload;
  int startTimeMilliseconds;

  @override
  String toString() {
    if (data is Map) {
      // Log encoded maps for better readability.
      return json.encode(data);
    }
    return data.toString();
  }
}
