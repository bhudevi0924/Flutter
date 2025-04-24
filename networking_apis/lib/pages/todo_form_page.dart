import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../services/todo_service.dart';

class TodoFormPage extends StatefulWidget {
  final Todo? todo;

  const TodoFormPage({super.key, this.todo});

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskController;
  String _status = 'Pending';

  final TodoService _service = TodoService();

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.todo?.task ?? '');
    _status = widget.todo?.status ?? 'Pending';
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {    //avoids giving warnings 
        print('status $_status');
      }
      final newTodo = Todo(
        id: widget.todo?.id,
        task: _taskController.text,
        status: _status
      );

      if (widget.todo == null) {
        await _service.createTodo(newTodo);
      } else {
        await _service.updateTodo(widget.todo!.id!, newTodo);
      }

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
    final isEditing = widget.todo != null;
    print(widget.todo);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Todo" : "Create Todo"),
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
                child: Text(isEditing ? "Update" : "Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
