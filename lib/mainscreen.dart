import 'package:flutter/material.dart';
import 'package:hello_todo_list/add_task.dart';
import 'package:hello_todo_list/todo_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already exists"),
            content: Text("Tis task is already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context);
  }

  void localData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = (prefs.getStringList("todoList") ?? []).toList();
    });
  }

  void writeLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  @override
  void initState() {
    super.initState();
    localData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Text("Drawer")),
      appBar: AppBar(title: const Text("TODO App"), centerTitle: true),
      body: (todoList.isEmpty)
          ? Center(
              child: Text(
                "No items on th List",
                style: TextStyle(fontSize: 20),
              ),
            )
          : TodoListView(
              items: todoList,
              onTap: (index) => taskDone(context, index),
              onDismissed: (index) {
                setState(() => todoList.removeAt(index));
                writeLocalData();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTo(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void taskDone(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                todoList.removeAt(index);
              });
              writeLocalData();
              Navigator.pop(context);
            },
            child: Text("Task Done!"),
          ),
        );
      },
    );
  }

  void addTo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(height: 250, child: AddTask(todoText: addTodo)),
        );
      },
    );
  }
}
