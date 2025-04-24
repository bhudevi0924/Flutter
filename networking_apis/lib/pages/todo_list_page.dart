import 'package:flutter/material.dart';
import 'package:networking_apis/pages/todo_form_shared_preference.dart';
import '../model/todo.dart';
import '../services/todo_service.dart';
import 'todo_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoService _service = TodoService();
  late Future<List<Todo>> _todoList;

  // Save data (like `localStorage.setItem('key', value)`)
  Future<void> setItem(String key, value) async {
    final prefs =await SharedPreferences.getInstance();
    if(value is int) {
      await prefs.setInt(key, value);
    } else if(value is String) {
      await prefs.setString(key, value);
    } else {
      throw Exception("Unsupported format!");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    _todoList = _service.fetchTodos();
  }

  void _refresh() {
    setState(() {
      _loadTodos();
    });
  }

  void _deleteTodo(int id) async {
    await _service.deleteTodo(id);
    _refresh();
  }

  void _navigateToForm({Todo? todo}) async {

    if(todo!=null){
    print('${todo.id} ${todo.status} ${todo.task}');
    setItem('todoId', todo.id);
    setItem("todoStatus", todo.status);
    setItem("todoText", todo.task);
    }

    //handle both edit and update in single page.
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => TodoFormPage(todo: todo)),
    // );

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => todo== null ? TodoFormPage(todo: todo,) : TodoFormSharedPreference()),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: FutureBuilder<List<Todo>>(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No todos found."));
          }

          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (_, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.task),
                subtitle: Text(todo.status),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToForm(todo: todo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(todo.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
