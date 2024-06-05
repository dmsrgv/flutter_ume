import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'widgets/icon.dart' as icon;
import 'widgets/pluggable_state.dart';

class ErrorsInspector extends StatefulWidget implements Pluggable {
  ErrorsInspector({Key? key}) : super(key: key);

  @override
  ErrorsInspectorPluggableState createState() => ErrorsInspectorPluggableState();

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'ErrorsInspector';

  @override
  String get displayName => 'ErrorsInspector';

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}
