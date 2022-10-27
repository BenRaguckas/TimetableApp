import 'package:flutter/material.dart';
import 'package:timetable/src/model/table_day.dart';
import 'package:timetable/src/model/table_full.dart';

class TableViewFull extends StatefulWidget {
  final TableFull table;
  const TableViewFull(this.table, {super.key});

  @override
  State<StatefulWidget> createState() => _TableViewFull();
}

class _TableViewFull extends State<TableViewFull> {
  final PageController _controller = PageController(
    initialPage: DateTime.now().weekday - 1,
  );

  //  TEST
  GlobalKey gk = GlobalKey();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gk;
      // _overlayEntry = _createOverlay();
      // overlayState!.insert(_overlayEntry!);
    });
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var oe = OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        height: 100.0,
        width: 500.0,
        child: CompositedTransformFollower(
          link: _layerLink,
          // offset: const Offset(0.0, 5.0),
          child: const Material(
            elevation: 1.0,
            color: Color.fromARGB(100, 250, 60, 60),
          ),
        ),
      ),
    );
    return oe;
  }
  //  TEST END

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            //  height should be determined by time querried
            height: 1500,
            child: columnGet(context),
          ),
        ),
        Positioned(
          top: 75.0,
          height: 10.0,
          width: 500.0,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0.0, 50.0),
            child: const Material(
              elevation: 5.0,
              color: Color.fromARGB(100, 250, 60, 60),
            ),
          ),
        ),
      ],
    );
  }

  Widget columnGet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //  Timeline
        Expanded(
          flex: 2,
          child: CompositedTransformTarget(
            link: _layerLink,
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
        ),
        //  Day list
        Expanded(
          flex: 8,
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: _fullView(context, widget.table),
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
