import 'package:pbkk_isar/models/enums.dart';
import 'package:isar/isar.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? content;

  @enumerated
  Status status = Status.pending;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Todo copyWith({
    String? content,
    Status? status,
  }) {
    return Todo()..id = id
        ..createdAt = createdAt
        ..updatedAt = DateTime.now()
        ..content = content ?? this.content
        ..status = status ?? this.status;
  }
}