import 'dart:math';
import 'package:flutter/material.dart';

class IsolatesUiBlock extends StatefulWidget {
  const IsolatesUiBlock({super.key});

  @override
  State<IsolatesUiBlock> createState() => _IsolatesUiBlockState();
}

class _IsolatesUiBlockState extends State<IsolatesUiBlock> {
  String _result = "Press the button to start computation";

  void _compute() {
    int sum = longRunningTask(); // This blocks the UI
    setState(() {
      _result = "Sum: $sum";
    });
  }

  int longRunningTask() {
    int sum = 0;
    for (int i = 0; i < 100000000; i++) {
      sum += Random().nextInt(10);
    }
    return sum;
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
        onPressed: _compute,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}


// 💡 Problem: Since longRunningTask() runs on the main isolate, it blocks the UI, making the app unresponsive.

