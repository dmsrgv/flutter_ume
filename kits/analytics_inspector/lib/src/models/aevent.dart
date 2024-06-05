enum AEventType {
  ecommerce,
  userProfile,
  custom,
}

class AEvent {
  AEvent({
    this.name,
    AEventType? eventType,
    int? startTimeMilliseconds,
    Map<String, dynamic>? payload,
  })  : payload = payload ?? <String, dynamic>{},
        eventType = eventType ?? AEventType.custom,
        startTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

  String? name;
  AEventType eventType;
  Map<String, dynamic> payload;
  int startTimeMilliseconds;
}
