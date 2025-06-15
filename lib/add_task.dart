import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final void Function({required String todoText}) todoText;
  const AddTask({super.key, required this.todoText});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var addTodo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Add task"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: addTodo,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (addTodo.text != '') {
              widget.todoText(todoText: addTodo.text);
            }
            addTodo.clear();
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
