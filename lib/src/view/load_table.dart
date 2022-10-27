import 'package:flutter/material.dart';
import 'package:timetable/src/model/table_full.dart';

import '../model/table_day.dart';
import 'day_view.dart';

class ShowTable extends StatefulWidget {
  final Future<Map<String, TableDay>> days;
  final Map<String, String> options;
  const ShowTable(this.days, this.options, {Key? key}) : super(key: key);

  @override
  State<ShowTable> createState() => _ShowTable();
}

//  Wrap the whole in FutureBuilder<Scaffold>
//  Look into sliding side views (to isolate days individually)
//  https://medium.com/flutter-community/flutter-pageview-widget-e0f6c8092636
class _ShowTable extends State<ShowTable> {
  final PageController _controller = PageController(
    initialPage: 0,
    //  Size of display (anything below 1.0 allows seeing side objects)
    viewportFraction: 0.95,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            return TableView(TableFull(snapshot.data!, widget.options));
          }
        },
      ),
    );
  }
}
