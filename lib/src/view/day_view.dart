import 'package:flutter/material.dart';

class DayView extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          height: 1500,
          child: columnGet(context),
        ),
      ),
    );
  }

  Widget columnGet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child:
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
            child: const Text("1"),
          ),
        ),
        //  c2
        Expanded(
          flex: 6,
          child: 
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
            child: const Text("2"),
          ),
        ),
      ],
    );
  }
}