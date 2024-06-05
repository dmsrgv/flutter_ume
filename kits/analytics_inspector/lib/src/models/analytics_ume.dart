import 'package:analytics_inspector/src/instances.dart';
import 'package:analytics_inspector/src/models/aevent.dart';

class AnalyticsUme {
  AnalyticsUme._();
  static void addEvent(AEvent event) =>
      InspectorInstance.analyticsContainer.addEvent(event);
}
