import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:http_inspector/src/models/ume_http_response.dart';

/// Implements a [ChangeNotifier] to notify listeners when new responses
/// were recorded. Use [page] to support paging.
class HttpContainer extends ChangeNotifier {
  /// Store all responses.
  List<UMEHttpResponse> get responses => _responses;
  final _responses = <UMEHttpResponse>[];

  /// Paging fields.
  int get page => _page;
  int _page = 1;
  final int _perPage = 10;

  /// Return responses according to the paging.
  List<UMEHttpResponse> get pagedResponses {
    return _responses.sublist(0, math.min(page * _perPage, _responses.length));
  }

  bool get _hasNextPage => _page * _perPage < _responses.length;

  void addResponse(UMEHttpResponse response) {
    _responses.insert(0, response);
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

  void clearRequests() {
    _responses.clear();
    _page = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    _responses.clear();
    super.dispose();
  }
}
