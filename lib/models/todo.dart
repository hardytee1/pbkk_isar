
import 'package:isar/isar.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? content;
  String? title;
  String? caption;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Todo copyWith({
    String? content,
    String? title,
    String? caption,
  }) {
    return Todo()..id = id
        ..createdAt = createdAt
        ..updatedAt = DateTime.now()
        ..content = content ?? this.content
        ..title = title ?? this.title
        ..caption = caption ?? this.caption;
  }
}