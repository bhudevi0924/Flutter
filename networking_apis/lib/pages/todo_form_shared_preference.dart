import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../services/todo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

//displayimg todo items by storing with shared preferences
class TodoFormSharedPreference extends StatefulWidget {

  const TodoFormSharedPreference({super.key});

  @override
  State<TodoFormSharedPreference> createState() => _TodoFormSharedPreferenceState();
}

class _TodoFormSharedPreferenceState extends State<TodoFormSharedPreference> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskController;
  String _status = 'Pending';
  int _id =0;
  String _task='new task';

  final TodoService _service = TodoService();


  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();

    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final int? todoId = prefs.getInt("todoId");
    final String? todoText = prefs.getString("todoText");
    final String? todoStatus = prefs.getString("todoStatus");

    setState(() {
      _taskController.text = todoText ?? '';
      _status = todoStatus ?? 'Pending';
      _id = todoId ??0;
      _task = todoText ?? "new task";
    });

    debugPrint('Todo ID: $todoId');
    debugPrint('Task: $todoText');
    debugPrint('Status: $todoStatus');
  }


  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {    //avoids giving warnings for print
        print('status $_status');
      }
      final newTodo = Todo(
        id: _id,
        task: _taskController.text,
        status: _status
      );

      await _service.updateTodo(_id, newTodo);
      

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: "Task"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a task" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'Not started', child: Text('Not started')),
                  DropdownMenuItem(value: 'In progress', child: Text('In progress')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                ],
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
