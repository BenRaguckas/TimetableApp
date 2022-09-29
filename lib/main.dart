import 'package:flutter/material.dart';
import 'browser.dart';

void main() {
  runApp(const TimetableApp());
}

class TimetableApp extends StatefulWidget {
  const TimetableApp({Key? key}) : super(key: key);

  @override
  State<TimetableApp> createState() => _TimetableAppState();
}

class _TimetableAppState extends State<TimetableApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("TimetableApp"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print("test");
            getHttp();
          },
        ),
      ),
    );
  }
}
