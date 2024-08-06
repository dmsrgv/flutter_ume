import 'package:flutter/material.dart';

import '../../errors_inspector.dart';
import '../instances.dart';

ButtonStyle _buttonStyle(BuildContext context) => ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(
        Colors.red[400],
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 3,
        ),
      ),
      minimumSize: WidgetStateProperty.all(Size.zero),
    );

class ErrorsInspectorPluggableState extends State<ErrorsInspector> {
  @override
  void initState() {
    super.initState();
    InspectorInstance.errorsContainer.addListener(_listener);
  }

  @override
  void dispose() {
    InspectorInstance.errorsContainer
      ..removeListener(_listener) // First, remove refresh listener.
      ..resetPaging(); // Then reset the paging field.
    super.dispose();
  }

  /// Using [setState] won't cause too much performance regression,
  /// since we've implemented the list with `findChildIndexCallback`.
  void _listener() {
    Future.microtask(() {
      if (mounted && !context.debugDoingBuild && context.owner?.debugBuilding != true) {
        setState(() {});
      }
    });
  }

  Widget get _itemList {
    final errors = InspectorInstance.errorsContainer.pagedErrors;
    final length = errors.length;

    if (length > 0) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final error = errors[index];
                if (index == length - 2) {
                  InspectorInstance.errorsContainer.loadNextPage();
                }

                return _ErrorCard(key: ValueKey(index), errorData: error);
              },
              childCount: length,
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Text(
        'Пока ошибок нет...\n🧐',
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
                        'Список ошибок',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: ElevatedButton(
                            onPressed: InspectorInstance.errorsContainer.clearErrors,
                            style: _buttonStyle(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Очистить',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.cleaning_services,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).canvasColor,
                    child: _itemList,
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

class _ErrorCard extends StatefulWidget {
  const _ErrorCard({
    required this.errorData,
    Key? key,
  }) : super(key: key);

  final UMEErrorData errorData;

  @override
  _ErrorCardState createState() => _ErrorCardState();
}

class _ErrorCardState extends State<_ErrorCard> {
  late final ValueNotifier<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  void _switchExpand() => _isExpanded.value = !_isExpanded.value;

  DateTime get _errorEventTime => DateTime.fromMillisecondsSinceEpoch(
        widget.errorData.startTimeMilliseconds,
      );

  @override
  Widget build(BuildContext context) {
    final errorData = widget.errorData;

    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: Theme.of(context).canvasColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_errorEventTime.hms()),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${errorData.error}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _switchExpand,
                  style: _buttonStyle(context),
                  child: const Text(
                    'Детали 🔍',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isExpanded,
              builder: (_, bool value, __) {
                if (!value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('${errorData.error}'),
                      SizedBox(height: 16),
                      Text(
                        'StackTrace:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('${errorData.trace}'),
                    ],
                  ),
                );
              },
            ),
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
}
