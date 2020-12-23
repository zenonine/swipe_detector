import 'package:flutter/material.dart';
import 'package:swipe_detector/swipe_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Detector Demo',
      home: MyHomePage(title: 'Swipe Detector Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalKey _buttonKey;

  @override
  void initState() {
    super.initState();
    _buttonKey = LabeledGlobalKey('button');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwipeVerticalDetector(
              behavior: HitTestBehavior.translucent,
              beforeSwipeStart: (details) {
                print(details);
                return true;
              },
              onSwipe: (details) {
                print(details);
              },
              child: RaisedButton(
                key: _buttonKey,
                onPressed: () {
                  print('onPressed');
                },
                child: Text('Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
