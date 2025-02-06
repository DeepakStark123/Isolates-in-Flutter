/*
Example: Running Two Isolates in Parallel

Below is an example where we create two separate isolates:

1. One isolate calculates the sum of random numbers.
2. Another isolate finds the factorial of a number.

Both isolates will send results back to the UI.
*/

import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';

class TwoIsolatesExample extends StatefulWidget {
  const TwoIsolatesExample({super.key});

  @override
  State<TwoIsolatesExample> createState() => _TwoIsolatesExampleState();
}

class _TwoIsolatesExampleState extends State<TwoIsolatesExample> {
  String _sumResult = "Press to compute sum";
  String _factorialResult = "Press to compute factorial";

  void _computeSum() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(sumTask, receivePort.sendPort);

    receivePort.listen((message) {
      setState(() {
        _sumResult = "Sum: $message";
        debugPrint(_sumResult);
      });
    });
  }

  void _computeFactorial() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(factorialTask, receivePort.sendPort);

    receivePort.listen((message) {
      setState(() {
        _factorialResult = "Factorial: $message";
        debugPrint(_factorialResult);
      });
    });
  }

  static void sumTask(SendPort sendPort) {
    int sum = 0;
    for (int i = 0; i < 100000000; i++) {
      sum += Random().nextInt(10);
    }
    sendPort.send(sum);
  }

  static void factorialTask(SendPort sendPort) {
    int number = 10; 
    BigInt factorial = BigInt.one;
    for (int i = 1; i <= number; i++) {
      factorial *= BigInt.from(i);
    }
    sendPort.send(factorial.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multiple Isolates Example")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_sumResult),
          const SizedBox(height: 20),
          Text(_factorialResult),
          const SizedBox(height: 50),
          FloatingActionButton.extended(
            onPressed: _computeSum,
            label: const Text("Compute Sum"),
          ),
          const SizedBox(height: 20),
          FloatingActionButton.extended(
            onPressed: _computeFactorial,
            label: const Text("Compute Factorial"),
          ),
        ],
      ),
    );
  }
}
