import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

class ShowTable extends StatefulWidget {
  final TimeTable tt;
  const ShowTable(this.tt, {Key? key}) : super(key: key);

  @override
  State<ShowTable> createState() => _ShowTable();
}

class _ShowTable extends State<ShowTable> {
  @override
  Widget build(BuildContext context) {
    print(widget.tt.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHOW'),
      ),
      body: Text(widget.tt.day[0].toString()),
    );
  }
}

class StateTest extends StatelessWidget {
  const StateTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
