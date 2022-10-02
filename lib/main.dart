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
  TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');
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
            if (await tb.getInitialUrl()) print("Got timetable url from ${tb.targetUri}");
            if (await tb.getLoginForm()) print("Got login form from ${tb.targetUri}");
            if (await tb.submitLoginForm()) print("submit");

            // if (await tb.getInitialUrl('https://timetable.ait.ie/')) print("Got timetable url from ${tb.targetUri}");
            // if (await tb.getLoginForm(tb.targetUri)) print("Got login form from ${tb.targetUri}");
            // if (await tb.submitLoginForm(tb.targetUri)) print("submit");
          },
        ),
      ),
    );
  }
}
