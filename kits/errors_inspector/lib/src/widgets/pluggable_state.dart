import 'package:flutter/material.dart';

import '../../errors_inspector.dart';
import '../instances.dart';

ButtonStyle _buttonStyle(BuildContext context) => ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all(
        Theme.of(context).primaryColor,
      ),
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 3,
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size.zero),
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
      if (mounted &&
          !context.debugDoingBuild &&
          context.owner?.debugBuilding != true) {
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
                return _ErrorCard(
                  key: ValueKey(index),
                  errorData: error,
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
        'Come back later...\n🧐',
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
                        'Errors List',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: ElevatedButton(
                            onPressed:
                                InspectorInstance.errorsContainer.clearErrors,
                            style: _buttonStyle(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Clear',
                                  style: TextStyle(color: Colors.white),
                                ),
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
    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: Theme.of(context).canvasColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _switchExpand,
                style: _buttonStyle(context),
                child: const Text(
                  'Детали 🔍',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
                      Text('${widget.errorData.data}'),
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

  String dayMonthYear([String separator = '/']) =>
      '${day.toString().padLeft(2, '0')}$separator'
      '${month.toString().padLeft(2, '0')}$separator'
      '$year';
}
