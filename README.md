 # ppb_isar
 ## 5025221271_Hardy Tee

 # Configurasi
 ## Tambahkan code berikut tepat dibawah cupertino_icons, versi mengikuti versi terbaru yang ada
 ```
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.5
```
 ## Tambahkan code berikut tepat dibawah flutter_lints, versi mengikuti versi terbaru yang ada
 ```
  isar_generator: ^3.1.0+1
  build_runner: any
```
## Setelah itu lakukan code berikut di terminal untuk mendapatkan dependecy diatas
```
flutter pub get
```
## Membuat file model sebagai schema tabel
```
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
```
