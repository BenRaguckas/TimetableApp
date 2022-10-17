import 'package:quiver/core.dart';

class SubjectTimeSlot {
  int hour, min;

  SubjectTimeSlot(this.hour, this.min);
  SubjectTimeSlot.fromString(String time)
      : hour = int.parse(time.split(':').first),
        min = int.parse(time.split(':').last);

  bool operator <(SubjectTimeSlot b) => hour < b.hour || (hour == b.hour && min < b.min);

  bool operator >(SubjectTimeSlot b) => hour > b.hour || (hour == b.hour && min > b.min);

  bool operator <=(SubjectTimeSlot b) => hour < b.hour || (hour == b.hour && min < b.min) || this == b;

  bool operator >=(SubjectTimeSlot b) => hour > b.hour || (hour == b.hour && min > b.min) || this == b;

  @override
  bool operator ==(Object other) => other is SubjectTimeSlot && hour == other.hour && min == other.min;

  //  Dont ask don't tell, for reference:
  //  https://stackoverflow.com/questions/20577606/whats-a-good-recipe-for-overriding-hashcode-in-dart
  @override
  int get hashCode => hash2(hour.hashCode, min.hashCode);

  @override
  String toString() {
    return '${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}';
  }
}
