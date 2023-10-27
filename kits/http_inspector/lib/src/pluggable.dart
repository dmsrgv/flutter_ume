import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'widgets/icon.dart' as icon;
import 'widgets/pluggable_state.dart';

class HttpInspector extends StatefulWidget implements Pluggable {
  HttpInspector({Key? key}) : super(key: key);

  @override
  HttpInspectorPluggableState createState() => HttpInspectorPluggableState();

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'HttpInspector';

  @override
  String get displayName => 'HttpInspector';

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}
