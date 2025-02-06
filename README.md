# Isolates in Flutter

## Overview
This project demonstrates how to use **isolates** in Flutter to handle expensive computations without blocking the UI. Flutter uses a single-threaded execution model, but isolates allow us to run tasks in parallel by creating separate memory spaces.

## What Are Isolates?
Isolates are independent threads in Dart that **do not share memory** with the main thread. Instead, they communicate by passing messages using `SendPort` and `ReceivePort`.

### Why Use Isolates?
- Running heavy computations in the main thread **blocks the UI**, causing lag.
- Isolates run tasks in **parallel**, keeping the UI responsive.

## Project Structure

This project contains multiple examples demonstrating the use of isolates:

- **`lib/main.dart`** - Entry point of the app.
- **`lib/isolates_example.dart`** - Basic example showing how to use a single isolate.
- **`lib/two_isolates_example.dart`** - Demonstrates running two isolates in parallel.
- **`lib/isolates_ui_block.dart`** - Shows how the UI gets blocked when performing a heavy computation on the main thread.

## How to Run the Project
1. Clone the repository:
   ```sh
   git clone https://github.com/DeepakStark123/Isolates-in-Flutter
   cd isolates_in_flutter
   ```
2. Get dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Example 1: Without Isolates (Blocking UI)

In **`isolates_ui_block.dart`**, a long computation is performed **on the main thread**, causing UI lag:

```dart
void longRunningTask() {
  int sum = 0;
  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }
}
```

**Problem:** The UI freezes while this function runs.

## Example 2: Using a Single Isolate

In **`isolates_example.dart`**, the same task is moved to an **isolate**, keeping the UI responsive:

```dart
void startIsolate() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(longRunningTask, receivePort.sendPort);
  receivePort.listen((message) {
    print("Result from isolate: $message");
  });
}

static void longRunningTask(SendPort sendPort) {
  int sum = 0;
  for (int i = 0; i < 100000000; i++) {
    sum += i;
  }
  sendPort.send(sum);
}
```

**Solution:** The heavy task runs in the isolate, and results are sent back using `SendPort`.

## Example 3: Running Two Isolates in Parallel

In **`two_isolates_example.dart`**, two isolates run different tasks **simultaneously**:

```dart
void startTwoIsolates() {
  ReceivePort receivePort1 = ReceivePort();
  ReceivePort receivePort2 = ReceivePort();

  Isolate.spawn(task1, receivePort1.sendPort);
  Isolate.spawn(task2, receivePort2.sendPort);

  receivePort1.listen((message) => print("Task 1 result: $message"));
  receivePort2.listen((message) => print("Task 2 result: $message"));
}
```

**Result:** Both isolates execute independently, improving performance.

## Conclusion
Using isolates in Flutter can significantly improve app performance by offloading expensive computations. This project provides hands-on examples to help developers understand and implement isolates effectively.

### 🌟 Feel free to contribute and explore more!

---

**Author:** Your Name  
**GitHub:** [Your GitHub Profile](https://github.com/DeepakStark123)
# Isolates-in-Flutter
