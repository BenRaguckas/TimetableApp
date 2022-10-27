import 'package:quiver/core.dart';
import 'dart:math' as math;

class FormOptionItem {
  final String id;
  final String name;

  FormOptionItem(this.id, this.name);

  @override
  bool operator ==(Object other) => other is FormOptionItem && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, name.hashCode);

  @override
  String toString() => name;

  String trimName() {
    if (name.contains(id.substring(0, math.min(5, id.length)))) {
      return name.substring(name.indexOf(' '), name.length).trim();
    }
    return name;
  }
}
