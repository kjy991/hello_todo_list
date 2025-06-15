import 'package:flutter/material.dart';

/// 할 일 리스트뷰를 그려주는 위젯
class TodoListView extends StatelessWidget {
  final List<String> items;
  final void Function(int index) onDismissed;
  final void Function(int index) onTap;

  const TodoListView({
    super.key,
    required this.items,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(items[index]),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: const Icon(Icons.check, color: Colors.white),
          ),
          onDismissed: (_) => onDismissed(index),
          child: ListTile(title: Text(items[index]), onTap: () => onTap(index)),
        );
      },
    );
  }
}
