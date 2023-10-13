enum AEventType {
  ecommerce,
  userProfile,
  custom,
}

class AEvent {
  AEvent({
    this.name,
    this.eventType,
    int? startTimeMilliseconds,
    Map<String, dynamic>? payload,
  })  : payload = payload ?? <String, dynamic>{},
        startTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

  String? name;
  AEventType? eventType;
  Map<String, dynamic> payload;
  int startTimeMilliseconds;
}
