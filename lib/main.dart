import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolates_example/demo_isolates.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isolates'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DartIsolateWidget(),
            FlutterIsolateWidget(),
          ],
        ),
      ),
    );
  }
}

class DartIsolateWidget extends StatefulWidget {
  @override
  _DartIsolateWidgetState createState() => _DartIsolateWidgetState();
}

class _DartIsolateWidgetState extends State<DartIsolateWidget> {
  StoppableIsolate isolate;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Dart Isolates',
              ),
            ),
            Switch(
              value: isolate != null,
              onChanged: (bool checked) async {
                if (checked) {
                  StoppableIsolate isolate = await spawnIsolate();
                  setState(() {
                    this.isolate = isolate;
                  });
                } else {
                  isolate.stop();
                  setState(() {
                    isolate = null;
                  });
                }
              },
            ),
          ],
        ),
      );
}

class FlutterIsolateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      colorBrightness: Brightness.dark,
      color: Colors.blue,
      onPressed: () async {
        String result = await compute(flutterIsolateComputation, null);
        print('RECEIVED: ' + result);
      },
      child: Text(
        'Flutter Isolates',
      ),
    );
  }
}
