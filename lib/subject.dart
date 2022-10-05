import 'package:quiver/core.dart';

class Subject implements Comparable<Subject> {
  String title, module, type, weeks;
  TimeSlot start, finish, duration;
  Room room;
  List<String> groups, staff;

  Subject(this.title, this.module, this.type, this.start, this.finish, this.duration, this.weeks, this.room, this.staff, this.groups);
  Subject.fromList(List<String> list)
      : title = list[0].trim(),
        module = list[1].trim(),
        type = list[2].trim(),
        start = TimeSlot.fromString(list[3].trim()),
        finish = TimeSlot.fromString(list[4].trim()),
        duration = TimeSlot.fromString(list[5].trim()),
        weeks = list[6].trim(),
        room = Room.fromSingle(list[7].trim()),
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
    } else if (start > other.start) {
      return 1;
    } else {
      return 0;
    }
  }
}

class Room {
  String room, desc;

  Room(this.room, this.desc);
  Room.fromSingle(String roomInfo)
      : room = roomInfo.split(' ').first,
        desc = roomInfo.substring(roomInfo.indexOf(' ') + 1);

  @override
  bool operator ==(Object other) => other is Room && room == other.room;

  @override
  int get hashCode => hash2(room.hashCode, desc.hashCode);

  @override
  String toString() {
    return room;
  }
}

class TimeSlot {
  int hour, min;

  TimeSlot(this.hour, this.min);
  TimeSlot.fromString(String time)
      : hour = int.parse(time.split(':').first),
        min = int.parse(time.split(':').last);

  bool operator <(TimeSlot b) => hour < b.hour || (hour == b.hour && min < b.min);

  bool operator >(TimeSlot b) => hour > b.hour || (hour == b.hour && min > b.min);

  bool operator <=(TimeSlot b) => hour < b.hour || (hour == b.hour && min < b.min) || this == b;

  bool operator >=(TimeSlot b) => hour > b.hour || (hour == b.hour && min > b.min) || this == b;

  @override
  bool operator ==(Object other) => other is TimeSlot && hour == other.hour && min == other.min;

  //  Dont ask don't tell, for reference:
  //  https://stackoverflow.com/questions/20577606/whats-a-good-recipe-for-overriding-hashcode-in-dart
  @override
  int get hashCode => hash2(hour.hashCode, min.hashCode);

  @override
  String toString() {
    return '${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}';
  }
}
