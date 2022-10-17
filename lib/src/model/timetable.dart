import 'package:timetable/subject.dart';

class TimeTable {
  String title;
  List<List<Subject>> day = [];

  TimeTable(this.title, this.day);

  @override
  String toString() {
    String output = '';
    day.asMap().forEach((key, value) {
      switch (key) {
        case 0:
          output += '\nMonday\n';
          break;
        case 1:
          output += '\nTuesday\n';
          break;
        case 2:
          output += '\nWednesday\n';
          break;
        case 3:
          output += '\nThursday\n';
          break;
        case 4:
          output += '\nFriday\n';
          break;
      }
      value.forEach((element) {
        output += element.toString();
        output += '\n';
      });
    });
    return output;
  }
}
