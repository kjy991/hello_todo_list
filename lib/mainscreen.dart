import 'package:flutter/material.dart';
import 'package:hello_todo_list/add_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];

  void updateText({required String todoText}) {
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
      appBar: AppBar(
        title: const Text("TODO App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      height: 250,
                      child: AddTask(todoText: updateText),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
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
            },
            title: Text(todoList[index]),
          );
        },
      ),
    );
  }
}
