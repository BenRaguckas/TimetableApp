import 'package:quiver/core.dart';

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
}
