import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<StoppableIsolate> spawnIsolate() async {
  ReceivePort receivePort = new ReceivePort();
  Isolate isolate = await Isolate.spawn(someLongRunningOperation, receivePort.sendPort);
  receivePort.listen((data) {
    print('RECEIVED: ' + data);
  });
  return StoppableIsolate(isolate, receivePort);
}

// Isolate code
void someLongRunningOperation(SendPort sendPort) async {
  while (true) {
    sleep(Duration(seconds: 3));
    sendPort.send('Worked for 3 seconds');
  }
}

class StoppableIsolate {
  final Isolate isolate;
  final ReceivePort receivePort;

  StoppableIsolate(this.isolate, this.receivePort);

  void stop() {
    receivePort.close();
    isolate.kill();
  }
}
