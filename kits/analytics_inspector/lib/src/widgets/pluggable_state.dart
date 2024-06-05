///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/6 11:25
///
import 'dart:convert';

import 'package:analytics_inspector/src/models/aevent.dart';
import 'package:flutter/material.dart';

import '../instances.dart';
import '../pluggable.dart';

const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

ButtonStyle _buttonStyle(
  BuildContext context, {
  EdgeInsetsGeometry? padding,
}) {
  return TextButton.styleFrom(
    foregroundColor: Colors.white,
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    minimumSize: Size.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999999),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

class AnalyticsPluggableState extends State<AnalyticsInspector> {
  AEventType? filterType = null;

  @override
  void initState() {
    super.initState();
    // Bind listener to refresh events.
    InspectorInstance.analyticsContainer.addListener(_listener);
  }

  @override
  void dispose() {
    InspectorInstance.analyticsContainer
      ..removeListener(_listener) // First, remove refresh listener.
      ..resetPaging(); // Then reset the paging field.
    super.dispose();
  }

  /// Using [setState] won't cause too much performance regression,
  /// since we've implemented the list with `findChildIndexCallback`.
  void _listener() {
    Future.microtask(() {
      if (mounted &&
          !context.debugDoingBuild &&
          context.owner?.debugBuilding != true) {
        setState(() {});
      }
    });
  }

  Widget _clearAllButton(BuildContext context) {
    return TextButton(
      onPressed: InspectorInstance.analyticsContainer.clearEvents,
      style: _buttonStyle(
        context,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text('Clear'),
          Icon(Icons.cleaning_services, size: 14),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context) {
    final List<AEvent> events =
        InspectorInstance.analyticsContainer.filteredEvents;
    final int length = events.length;
    if (length > 0) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                final AEvent event = events[index];
                if (index == length - 2) {
                  InspectorInstance.analyticsContainer.loadNextPage();
                }
                return _EventCard(
                  key: ValueKey<int>(event.startTimeMilliseconds),
                  event: event,
                );
              },
              childCount: length,
            ),
          ),
        ],
      );
    }
    return const Center(
      child: Text(
        'Тут пока пусто...\n👀',
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyMedium,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints.tightFor(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.25,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      Text(
                        'Analytics Events',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _clearAllButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FilterButton(
                        text: 'Все',
                        color: Colors.green,
                      ),
                      FilterButton(
                        text: 'custom',
                        type: AEventType.custom,
                        color: Colors.blue,
                      ),
                      FilterButton(
                        text: 'userProfile',
                        type: AEventType.userProfile,
                        color: Colors.purple,
                      ),
                      FilterButton(
                        text: 'ecommerce',
                        type: AEventType.ecommerce,
                        color: Colors.red,
                      ),
                      FilterButton(
                        text: 'search',
                        type: AEventType.search,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).canvasColor,
                    child: _itemList(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({
    required Key? key,
    required this.event,
  }) : super(key: key);

  final AEvent event;

  @override
  _ResponseCardState createState() => _ResponseCardState();
}

class _ResponseCardState extends State<_EventCard> {
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  void _switchExpand() {
    _isExpanded.value = !_isExpanded.value;
  }

  AEvent get _event => widget.event;

  DateTime get _startTime =>
      DateTime.fromMillisecondsSinceEpoch(_event.startTimeMilliseconds);

  /// Status code for the [_response].
  AEventType get _eventType => _event.eventType ?? AEventType.custom;

  Color get _eventTypeColor => switch (_eventType) {
        AEventType.ecommerce => Colors.red,
        AEventType.userProfile => Colors.purple,
        AEventType.search => Colors.yellow,
        _ => Colors.blueAccent,
      };

  Widget _detailButton(BuildContext context) {
    return TextButton(
      onPressed: _switchExpand,
      style: _buttonStyle(context),
      child: const Text(
        'Детали',
        style: TextStyle(fontSize: 12, height: 1.2),
      ),
    );
  }

  Widget _infoContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(_startTime.hms()),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _eventTypeColor,
              ),
              child: Text(
                _eventType.name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 6),
            Text('${_startTime.dayMonthYear()}'),
            const Spacer(),
            _detailButton(context),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _event.name ?? 'Без имени',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _detailedContent(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _isExpanded,
        builder: (_, bool value, __) {
          if (!value) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _event.payload.entries
                  .map((entry) => Text('${entry.key} : ${entry.value} \n'))
                  .toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: Theme.of(context).canvasColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _infoContent(context),
            _detailedContent(context),
          ],
        ),
      ),
    );
  }
}

extension _DateTimeExtension on DateTime {
  String hms([String separator = ':']) => '$hour$separator'
      '${'$minute'.padLeft(2, '0')}$separator'
      '${'$second'.padLeft(2, '0')}';

  String dayMonthYear([String separator = '/']) =>
      '${day.toString().padLeft(2, '0')}$separator'
      '${month.toString().padLeft(2, '0')}$separator'
      '$year';
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.color,
    this.type,
    required this.text,
  });

  final Color? color;
  final AEventType? type;
  final String text;

  @override
  Widget build(BuildContext context) {
    final activeType = InspectorInstance.analyticsContainer.activeFilter;
    return TextButton(
        onPressed: () =>
            InspectorInstance.analyticsContainer.setActiveFilter(type),
        child: Text(
          '$text',
          style: TextStyle(
            fontSize: 12,
            color: activeType == type ? Colors.white : Colors.black,
          ),
        ),
        style: TextButton.styleFrom(
            backgroundColor: activeType == type ? color : null));
  }
}
