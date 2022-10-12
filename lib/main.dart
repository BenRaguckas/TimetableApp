import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:timetable/qurry_form.dart';
import 'browser.dart';

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
  final _formKey = GlobalKey<FormState>();

  // TimetableBrowser tb = TimetableBrowser('https://timetable.ait.ie/');

  QuerryForm qf = QuerryForm();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("TimetableApp"),
        ),
        body: FutureBuilder<Form>(
            future: qf.querryForm(context),
            builder: (context, snapshot) {
              //  Loading screen instead of Container
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data!;
              }
            }),
      ),

      // qf.querryForm(context),
      // ),
    );
  }
}
