import 'package:flutter/material.dart';
import 'dart:isolate';
import 'dart:math';

class IsoLatesExample extends StatefulWidget {
  const IsoLatesExample({super.key});

  @override
  State<IsoLatesExample> createState() => _IsoLatesExampleState();
}

class _IsoLatesExampleState extends State<IsoLatesExample> {
  String _result = "Press the button to start computation";

  void _computeUsingIsolate() async {
    final ReceivePort receivePort = ReceivePort();

    // Spawn an isolate
    await Isolate.spawn(longRunningTask, receivePort.sendPort);

    // Listen for the result from the isolate
    receivePort.listen((message) {
      setState(() {
        _result = "Sum: $message";
      });
    });
  }

  static void longRunningTask(SendPort sendPort) {
    int sum = 0;
    for (int i = 0; i < 100000000; i++) {
      sum += Random().nextInt(10);
    }
    sendPort.send(sum); // Send result back to main isolate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolate Example")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(_result)),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                debugPrint("Button Clicked");
              },
              child: const Text("Click"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _computeUsingIsolate,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

/*
💡 How it Works:

A ReceivePort is created to receive messages from the new isolate.
Isolate.spawn() starts a new isolate and sends it a SendPort to communicate.
The longRunningTask() function runs in the new isolate and sends the computed result back to the main isolate using the SendPort.
The receivePort.listen() gets the result and updates the UI.

*/