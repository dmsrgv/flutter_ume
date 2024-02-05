import 'containers/erros_container.dart';

/// The inner singleton instance to keep containers.
///
/// Currently we only have a http container here.
class InspectorInstance {
  const InspectorInstance._();

  static final ErrorsInspector errorsContainer = ErrorsInspector();
}
