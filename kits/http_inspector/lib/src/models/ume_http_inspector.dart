import 'package:http_inspector/src/instances.dart';
import 'package:http_inspector/src/models/ume_http_response.dart';

abstract class UmeHttpInspector {
  const UmeHttpInspector._();

  static void addResponse(UMEHttpResponse response) =>
      InspectorInstance.httpContainer.addResponse(response);
}
