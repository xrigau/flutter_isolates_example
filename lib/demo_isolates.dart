import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<StoppableIsolate> spawnIsolate() async {
  ReceivePort receivePort = new ReceivePort();
  Isolate isolate = await Isolate.spawn(dartIsolateLongRunningOperation, receivePort.sendPort);
  receivePort.listen((data) {
    print('RECEIVED: ' + data);
  });
  return StoppableIsolate(isolate, receivePort);
}

// Isolate code
void dartIsolateLongRunningOperation(SendPort sendPort) async {
  while (true) {
    sleep(Duration(seconds: 3));
    sendPort.send('Dart: Worked for 3 seconds');
  }
}

class StoppableIsolate {
  final Isolate isolate;
  final ReceivePort receivePort;

  StoppableIsolate(this.isolate, this.receivePort);

  void stop() {
    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
  }
}

// Isolate code
String flutterIsolateComputation(Null unused) {
  sleep(Duration(seconds: 3));
  return 'Flutter: Worked for 3 seconds';
}
