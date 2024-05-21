import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

bool _useCustomFeedback = false;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      child: MaterialApp(
        title: 'Feedback Demo',
        theme: ThemeData(
          primarySwatch: _useCustomFeedback ? Colors.green : Colors.blue,
        ),
        home: MyHomePage(_toggleCustomizedFeedback),
      ),
      // If custom feedback is not enabled, supply null and the default text
      // feedback form will be used.
      feedbackBuilder: _useCustomFeedback
          ? (context, onSubmit) => CustomFeedbackForm(
                onSubmit: onSubmit,
              )
          : null,
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),

      localeOverride: const Locale('en'),
      mode: FeedbackMode.draw,
      pixelRatio: 1,
    );
  }

  void _toggleCustomizedFeedback() =>
      setState(() => _useCustomFeedback = !_useCustomFeedback);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage(this.toggleCustomizedFeedback, {Key? key}) : super(key: key);

  final VoidCallback toggleCustomizedFeedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_useCustomFeedback
            ? '(Custom) Feedback Example'
            : 'Feedback Example'),
      ),
      drawer: Drawer(
        child: Container(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              const Text(
                '# How does it work?\n'
                '1. Just press the `Provide feedback` button.\n'
                '2. The feedback view opens. '
                'You can choose between draw and navigation mode. '
                'When in navigate mode, you can freely navigate in the '
                'app. Try it by opening the navigation drawer or by '
                'tapping the `Open scaffold` button. To switch to the '
                'drawing mode just press the `Draw` button on the right '
                'side. Now you can draw on the screen.\n'
                '3. To finish your feedback just write a message '
                'below and send it by pressing the `Submit` button.',
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Open scaffold'),
                onPressed: () {},
              ),
              const Divider(),
              ElevatedButton(
                child: const Text('Provide feedback'),
                onPressed: () {
                  BetterFeedback.of(context).show(
                    (feedback) async {},
                  );
                },
              ),
              const SizedBox(height: 10),
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                TextButton(
                  child: const Text('Provide E-Mail feedback'),
                  onPressed: () {
                    BetterFeedback.of(context).show((feedback) async {});
                  },
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                child: const Text('Provide feedback via platform sharing'),
                onPressed: () {
                  BetterFeedback.of(context).show(
                    (feedback) async {},
                  );
                },
              ),
              const Divider(),
              const Text('This is the example app for the "feedback" library.'),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Visit library page on pub.dev'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: const Text('toggle feedback mode',
            style: TextStyle(color: Colors.white)),
        onPressed: () {
          // don't toggle the feedback mode if it's currently visible
          if (!BetterFeedback.of(context).isVisible) {
            toggleCustomizedFeedback();
          }
        },
      ),
    );
  }
}
