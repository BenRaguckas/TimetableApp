import 'package:quiver/core.dart';

class SubjectRoom {
  String room, desc;

  SubjectRoom(this.room, this.desc);
  SubjectRoom.fromString(String roomInfo)
      : room = roomInfo.split(' ').first,
        desc = roomInfo.substring(roomInfo.indexOf(' ') + 1);

  @override
  bool operator ==(Object other) => other is SubjectRoom && room == other.room;

  @override
  int get hashCode => hash2(room.hashCode, desc.hashCode);

  @override
  String toString() {
    return room;
  }
}
