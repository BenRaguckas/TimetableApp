import 'package:timetable/src/model/subject_room.dart';
import 'package:timetable/src/model/subject_timeslot.dart';

class Subject implements Comparable<Subject> {
  final String title, module, type, weeks;
  final SubjectTimeSlot start, finish, duration;
  final SubjectRoom room;
  final List<String> groups, staff;

  Subject(this.title, this.module, this.type, this.start, this.finish, this.duration, this.weeks, this.room, this.staff, this.groups);
  Subject.fromList(List<String> list)
      : title = list[0].trim(),
        module = list[1].trim(),
        type = list[2].trim(),
        start = SubjectTimeSlot.fromString(list[3].trim()),
        finish = SubjectTimeSlot.fromString(list[4].trim()),
        duration = SubjectTimeSlot.fromString(list[5].trim()),
        weeks = list[6].trim(),
        room = SubjectRoom.fromString(list[7].trim()),
        staff = list[8].split(';'),
        groups = list[9].split(';');

  @override
  String toString() {
    return '${title.padLeft(35)}, $module, ${type.padLeft(8)}, $start - $finish, ${room.toString().padLeft(3)}, $staff';
  }

  @override
  int compareTo(Subject other) {
    if (start < other.start || finish < other.finish) {
      return -1;
    } else if (start > other.start || finish > other.finish) {
      return 1;
    } else {
      return 0;
    }
  }
}
