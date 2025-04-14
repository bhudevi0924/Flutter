import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'widgets/todo_item.dart';
import 'todo_details.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TodoHome(),  //main screen of the application
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo(String text) {
    if (text.isEmpty) return;
    setState(() {
      _todos.add(Todo(text: text));
      _controller.clear();
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Add a task'),
                    onSubmitted: _addTodo,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addTodo(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, i) => TodoItem(
                todo: _todos[i],
                onToggle: () => _toggleComplete(i),
                onDelete: () => _deleteTodo(i),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => TodoDetail(todo: _todos[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
