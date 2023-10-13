import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'widgets/icon.dart' as icon;
import 'widgets/pluggable_state.dart';

class AnalyticsInspector extends StatefulWidget implements Pluggable {
  AnalyticsInspector({
    Key? key,
  }) : super(key: key);

  @override
  AnalyticsPluggableState createState() => AnalyticsPluggableState();

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'Analytics';

  @override
  String get displayName => 'Analytics';

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}
