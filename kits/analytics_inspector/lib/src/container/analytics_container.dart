///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 2:49 PM
///
import 'dart:math' as math;

import 'package:analytics_inspector/src/models/aevent.dart';
import 'package:flutter/widgets.dart';

/// Implements a [ChangeNotifier] to notify listeners when new responses
/// were recorded. Use [page] to support paging.
class AnalyticsContainer extends ChangeNotifier {
  /// Store all responses.
  List<AEvent> get events => _events;
  final List<AEvent> _events = <AEvent>[];

  /// Paging fields.
  int get page => _page;
  int _page = 1;
  final int _perPage = 10;

  /// Return events according to the paging.
  List<AEvent> get pagedEvents {
    return _events.sublist(0, math.min(page * _perPage, _events.length));
  }

  bool get _hasNextPage => _page * _perPage < _events.length;

  void addEvent(AEvent event) {
    _events.insert(0, event);
    notifyListeners();
  }

  void loadNextPage() {
    if (!_hasNextPage) {
      return;
    }
    _page++;
    notifyListeners();
  }

  void resetPaging() {
    _page = 1;
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    _page = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    _events.clear();
    super.dispose();
  }
}
