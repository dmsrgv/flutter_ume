import 'package:example/ume_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:provider/provider.dart';
import 'package:analytics_inspector/analytics_inspector.dart';
import 'package:errors_inspector/errors_inspector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            onPressed: () => context.read<UMESwitch>().trigger(),
            icon: Icon(context.read<UMESwitch>().enable
                ? Icons.light
                : Icons.light_sharp),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => UMEWidget.closeActivatedPlugin(),
              child: const Text('Close activated plugin'),
            ),
            TextButton(
              onPressed: () => AnalyticsUme.addEvent(
                AEvent(
                    name:
                        'тестик большого прибольшого названия которое может быть еще больше если захотеть',
                    payload: {
                      'Название купона': 'Бурбон',
                      'Название салона': 'Кокол',
                      'Название погона': 'Нормальное такое название',
                    },
                    eventType: AEventType.userProfile),
              ),
              child: const Text('Добавить событие'),
            ),
            TextButton(
              onPressed: () => ErrorsUme.addError(
                UMEErrorData(
                  error: 'Ошибка: Что-то пошло не так...',
                  trace: StackTrace.current,
                ),
              ),
              child: const Text('Добавить ошибку'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('statement');
              },
              child: const Text('debugPrint'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('detail');
              },
              child: const Text('Push Detail Page'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Dialog'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
