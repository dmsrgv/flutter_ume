import '../../errors_inspector.dart';
import '../instances.dart';

class ErrorsUme {
  ErrorsUme._();

  static void addError(UMEErrorData errorData) =>
      InspectorInstance.errorsContainer.addError(errorData);
}
