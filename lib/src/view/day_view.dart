import 'package:flutter/material.dart';
import 'package:timetable/src/model/table_full.dart';

class TableView extends StatelessWidget {
  final TableFull table;

  TableView(this.table, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          //  height should be determined by time querried
          height: 1500,
          child: columnGet(context),
        ),
      ),
    );
  }

  final PageController _controller = PageController(
    //  initial page (set to weekday)
    initialPage: DateTime.now().weekday - 1,
    // initialPage: 0,
    //  Size of display (anything below 1.0 allows seeing side objects)
    // viewportFraction: 0.95,
  );

  Widget columnGet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        //  c2
        // Expanded(
        //   flex: 8,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [Colors.orange, Colors.red],
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //       ),
        //     ),
        //     child: const Text("2"),
        //   ),
        // ),
        Expanded(
          flex: 8,
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(table.days['Monday'].toString()),
              ),
              //  2
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text("2"),
              ),
              // 3
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text("3"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
