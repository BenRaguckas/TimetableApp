import 'package:timetable/src/model/subject.dart';

class TableDay {
  List<List<Subject>> allSubjects;

  TableDay(this.allSubjects);

  TableDay.create(List<Subject> subjects) : allSubjects = __processClashes(subjects);

  //  Divide list into more lists depending on clashing timeslots
  static List<List<Subject>> __processClashes(List<Subject> subjects) {
    //  Add given subjects to List
    List<List<Subject>> result = [];
    result.add(subjects);
    for (int i = 0; i < result.length; i++) {
      //  Store for convenience and sort
      var list = result[i];
      list.sort((a, b) {
        if (a.start < b.start) {
          return -1;
        } else if (a.start > b.start) {
          return 1;
        } else if (a.finish < b.finish) {
          return -1;
        } else if (a.finish > b.finish) {
          return 1;
        }
        return 0;
      });
      //  Divide up any clashes
      for (int j = 1; j < list.length; j++) {
        var pre = list[j - 1];
        var cur = list[j];
        if (cur.start < pre.finish) {
          if (result.length <= i + 1) result.add([]);
          result[i + 1].add(cur);
          result[i].remove(cur);
          j--;
        }
      }
    }

    return result;
  }

  @override
  String toString() {
    String output = "";
    for (var element in allSubjects) {
      output += "$element\n";
    }
    return output;
  }
}
