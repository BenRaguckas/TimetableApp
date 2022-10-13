import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

class ShowTable extends StatefulWidget {
  final Future<TimeTable> tt;
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
      body: FutureBuilder<String>(
        future: widget.tt.then((value) => value.toString()),
        builder: (context, snapshot) {
          //  Loading screen instead of Container
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Text(snapshot.data!);
          }
        },
      ),
    );
  }
}
