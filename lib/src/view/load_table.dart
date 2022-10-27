import 'package:flutter/material.dart';
import 'package:timetable/src/model/table_full.dart';
import 'package:timetable/src/view/table_view_ful.dart';

import '../model/table_day.dart';

class ShowTable extends StatefulWidget {
  final Future<Map<String, TableDay>> days;
  final Map<String, String> options;
  const ShowTable(this.days, this.options, {Key? key}) : super(key: key);

  @override
  State<ShowTable> createState() => _ShowTable();
}

class _ShowTable extends State<ShowTable> {
  //  Needs to be wrapped in scafold or something similar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.options['title']!),
      ),
      //  Build future using Map
      body: FutureBuilder<Map<String, TableDay>>(
        future: widget.days.then((value) => value),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            //  Build the table with specified data
            return TableViewFull(TableFull(snapshot.data!, widget.options));
          }
        },
      ),
    );
  }
}
