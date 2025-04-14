import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
   final VoidCallback onTap;

  const TodoItem({super.key, required this.todo, required this.onToggle, required this.onDelete,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        todo.text,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) => onToggle(),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
