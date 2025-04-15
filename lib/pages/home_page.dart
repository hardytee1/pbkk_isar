import 'dart:async';

import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Caption text
                  Text(todo.caption ?? 'No Caption'),
                  SizedBox(height: 8),
                  Image.network(
                    todo.content ?? 'No Content',
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error loading image');
                    },
                  ),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _addOrEditTodo(todo: todo,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await DatabaseService.db.writeTxn(() async {
                            await DatabaseService.db.todos.delete(todo.id,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
    }),
    );
  }

  void _addOrEditTodo({
    Todo? todo,
}) {
    TextEditingController contentController = TextEditingController(text :todo?.content?? "");
    TextEditingController titleController = TextEditingController(text :todo?.title?? "");
    TextEditingController captionController = TextEditingController(text :todo?.caption?? "");

    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title: Text(todo != null ? "Edit To Do":"Add To Do"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            ),
            TextField(controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
              ),
            ),
            TextField(controller: captionController,
              decoration: const InputDecoration(
                labelText: 'Caption',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('Cancel'),
        ),
        TextButton(onPressed: () async {
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
