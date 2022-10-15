import 'package:flutter/material.dart';
import 'package:timetable/qurry_form.dart';

const List<String> list = ['1', '2', '3', '4'];

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
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text("TimetableApp"),
          ),
          body: FutureBuilder<Form>(
            future: QuerryForm.create().then((value) => value.querryForm(context)),
            builder: (context, snapshot) {
              //  Loading screen instead of Container
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data!;
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("button for saved tt");
            },
          ),
        ),
      ),
    );
  }
}
