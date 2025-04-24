import 'package:flutter/foundation.dart';
import '../model/todo.dart';

class BasicTodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void add(String title) {
    if (title.isNotEmpty) {
      _todos.add(Todo(title: title));
      notifyListeners();
    }
  }

  void toggle(int index) {
    _todos[index].toggleDone();
    notifyListeners();
  }
}
