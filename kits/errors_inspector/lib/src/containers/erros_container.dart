import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../models/ume_error_data.dart';

/// Implements a [ChangeNotifier] to notify listeners when new errors
/// were recorded. Use [page] to support paging.
class ErrorsInspector extends ChangeNotifier {
  /// Store all errors.
  List<UMEErrorData> get errors => _errors;
  final _errors = <UMEErrorData>[];

  /// Paging fields.
  int get page => _page;
  int _page = 1;
  final int _perPage = 10;

  /// Return errors according to the paging.
  List<UMEErrorData> get pagedErrors {
    return _errors.sublist(0, math.min(page * _perPage, _errors.length));
  }

  bool get _hasNextPage => _page * _perPage < _errors.length;

  void addError(UMEErrorData errorData) {
    _errors.insert(0, errorData);
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

  void clearErrors() {
    _errors.clear();
    _page = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    _errors.clear();
    super.dispose();
  }
}
