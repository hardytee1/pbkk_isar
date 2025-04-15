import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbkk_isar/models/enums.dart';
import 'package:pbkk_isar/models/todo.dart';
import 'package:pbkk_isar/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  StreamSubscription? todoStream;
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

  @override
  void dispose() {
    // TODO: implement deactivate
    todoStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SizedBox.expand(
        child: _buildIU(),
      ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addOrEditTodo,
      child : const Icon(
        Icons.add,
      ),
      ),
    );
  }

  Widget _buildIU(){
    return Padding(padding: EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
      return Card(
        child: ListTile(
        title:Text(
          todo.content ?? "",
        ),
        subtitle: Text("Marked ${todo.status.name} at ${todo.updatedAt}"),
        trailing:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              _addOrEditTodo(todo: todo,
              );
            }, icon: const Icon(Icons.edit,),
            ),
            IconButton(onPressed: () async {
              await DatabaseService.db.writeTxn(() async {
                await DatabaseService.db.todos.delete(todo.id,
                );
              });
            }, icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            ),
          ],
        ),
        )
      );
    }),
    );
  }

  void _addOrEditTodo({
    Todo? todo,
}) {
    TextEditingController contentController = TextEditingController(text :todo?.content?? "");

    Status status = todo?.status ?? Status.pending;

    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title: Text(todo != null ? "Edit To Do":"Add To Do"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
            ),
            DropdownButtonFormField<Status>(
              value: status,
                items: Status.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                )
                .toList(),
                onChanged: (value) {
                if(value ==null) return;
                status = value;
                }),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('Cancel'),
        ),
        TextButton(onPressed: () async {
          if (contentController.text.isNotEmpty){
            Todo newTodo = Todo();
            newTodo = newTodo.copyWith(
                content: contentController.text,
                status: status,
            );
            await DatabaseService.db.writeTxn(
                () async {
                  await DatabaseService.db.todos.put(
                    newTodo,
                  );
                },
            );
            Navigator.pop(context);
          }
        }, child: const Text('Save'),
        )
        ],
      );
    },
    );
  }
}
