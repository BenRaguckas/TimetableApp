import 'package:flutter/material.dart';
import 'package:timetable/src/model/table_day.dart';
import 'package:timetable/src/model/table_full.dart';

class TableView extends StatelessWidget {
  final TableFull table;

  TableView(this.table, {super.key});

  //  TEST
  GlobalKey gk = GlobalKey();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  OverlayEntry _createOverlay(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200.0,
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }
  //  TEST END

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        //  height should be determined by time querried
        height: 1500,
        child: columnGet(context),
      ),
    );
  }

  final PageController _controller = PageController(
    //  initial page (set to weekday)
    initialPage: DateTime.now().weekday - 1,
    //  Size of display (anything below 1.0 allows seeing side objects)
    // viewportFraction: 0.98,
  );

  Widget columnGet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //  Timeline
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Text("1"),
          ),
        ),
        //  Day list
        Expanded(
          flex: 8,
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: _fullView(context, table),
          ),
        ),
      ],
    );
  }

  Widget _dayView(BuildContext context, TableDay content) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Text(content.dayName),
          Text(content.allSubjects.toString()),
        ],
      ),
    );
  }

  List<Widget> _fullView(BuildContext context, TableFull table) {
    List<Widget> days = [];
    table.days.forEach((key, value) {
      days.add(_dayView(context, table.days[key]!));
    });
    return days;
  }
}
