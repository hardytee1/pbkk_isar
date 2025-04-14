import 'package:flutter/material.dart';
import 'package:pbkk_isar/models/enums.dart';
import 'package:pbkk_isar/models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        itemCount: 10,
        itemBuilder: (context, index) {
      return Card(
        child: ListTile(
        title:Text("Todo $index",),
        trailing:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit,),
            ),
            IconButton(onPressed: () {}, icon: const Icon(
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

  void _addOrEditTodo(){
    Status status = Status.pending;

    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title: Text("Add To do"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(),
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
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('Save'),
        )
        ],
      );
    },
    );
  }
}
