 # ppb_isar
 ### 5025221271_Hardy Tee

 ## Configurasi
 ### Tambahkan code berikut tepat dibawah cupertino_icons, versi mengikuti versi terbaru yang ada
 ```
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.5
```
 ### Tambahkan code berikut tepat dibawah flutter_lints, versi mengikuti versi terbaru yang ada
 ```
  isar_generator: ^3.1.0+1
  build_runner: any
```
### Setelah itu lakukan code berikut di terminal untuk mendapatkan dependecy diatas
```
flutter pub get
```
### Membuat file model sebagai schema tabel, bagian ini "part 'todo.g.dart';" digunakan saat nanti migrasi schema tersebut
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
### Setelah itu run di terminal kode berikut untuk migrasi schema tersebut
```
flutter pub run build_runner build
```
### Memulai koneksi dengan database
```
import 'package:path_provider/path_provider.dart';
import 'package:pbkk_isar/models/todo.dart';
import 'package:isar/isar.dart';

class DatabaseService{

  static late final Isar db;

  static Future<void> setup() async {
    final appDir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [
        TodoSchema,
      ],
      directory: appDir.path,
    );
  }
}
```

## Membuat homepage, memulai design dan melakukan CRUD
### ditambahan list todo untuk menyimpan semua todo yang ada. dan stream digunakan untuk mendapatkan data dari Isar secara realtime
```
List<Todo> todos = [];
  StreamSubscription? todoStream;
```
### Mengambil data dari database
```
@override
  void initState(){
    super.initState();
    DatabaseService.db.todos
      .buildQuery<Todo>()
      .watch(
      fireImmediately: true,
    )
    .listen((data)
    {
      setState(() {
        todos = data;
      });
    },
    );
  }
```
### Menutup listening dari database, berguna saat keluar halaman
```
@override
  void dispose() {
    todoStream?.cancel();
    super.dispose();
  }
```
### karena sudah didalam list, maka untuk mengambil data pada attribut yang spesifik, menggunakan code berikut
```
todo.title ?? 'No Title'
```
### Melakukan delete dengan cara membuka transaksi lalu menggunakan metode delete dengan parameter id
```
IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await DatabaseService.db.writeTxn(() async {
                            await DatabaseService.db.todos.delete(todo.id,
                            );
                          });
                        },
                      ),
```
### Melakukan Create atau Update, jika edit/update maka data dari todo akan di copy dan dignti dengan data yang baru, namun jika create maka membuat todo baru dengan data yang baru juga. untuk menyimpan ke database, sama seperti saat delete, membuka transaction lalu menggunakan metode put.
```
if (titleController.text.isNotEmpty){
            late Todo newTodo;
            if (todo != null){
              newTodo = todo.copyWith(
                  title: titleController.text,
                  caption: captionController.text,
                  content: contentController.text,
              );
            }else{
              newTodo = Todo().copyWith(
                title: titleController.text,
                caption: captionController.text,
                content: contentController.text,
              );
            }
            await DatabaseService.db.writeTxn(
                () async {
                  await DatabaseService.db.todos.put(
                    newTodo,
                  );
                },
            );
```
### function copyWith yang digunakan untuk mengcopy data yang lama, lalu update dengan data yang baru namun menjaga untuk tidak merubah data krusial seperti id dan createdAt
```
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
```
