import 'package:flutter/material.dart';
import 'package:timetable/src/model/timetable.dart';

class ShowTable extends StatefulWidget {
  final Future<TimeTable> tt;
  const ShowTable(this.tt, {Key? key}) : super(key: key);

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
    viewportFraction: 0.8,
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
        title: FutureBuilder<String>(
          future: widget.tt.then((value) => value.title.toString()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Text(snapshot.data!);
            }
          },
        ),
      ),
      body: FutureBuilder<TimeTable>(
        future: widget.tt.then((value) => value),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              children: [
                _dayDisplay(snapshot.data!.day[0].toString()),
                _dayDisplay(snapshot.data!.day[1].toString()),
                _dayDisplay(snapshot.data!.day[2].toString()),
              ],
            );
          }
        },
      ),
    );
    // return PageView(
    //   controller: _controller,
    //   scrollDirection: Axis.horizontal,
    //   //  Populate with _dayDisplay
    //   children: [
    //     _dayDisplay('Mon'),
    //     _dayDisplay('Tue'),
    //     _dayDisplay('Wed'),
    //   ],
    // );
  }

  //  Original builder
  // @override
  // Widget build(BuildContext context) {
  //   print(widget.tt.toString());
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('SHOW'),
  //     ),
  //     body: FutureBuilder<String>(
  //       future: widget.tt.then((value) => value.toString()),
  //       builder: (context, snapshot) {
  //         //  Loading screen instead of Container
  //         if (!snapshot.hasData) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else {
  //           return Text(snapshot.data!);
  //         }
  //       },
  //     ),
  //   );
  // }

  //  Placeholder for single subject display (multiple of these used in _dayDisplay)
  Widget _subjectItem() {
    return Scaffold();
  }

  //  Placeholder for day display (multiples of these to be used for the week)
  Widget _dayDisplay(String input) {
    return Scaffold(
      body: Text(input),
    );
  }
}
