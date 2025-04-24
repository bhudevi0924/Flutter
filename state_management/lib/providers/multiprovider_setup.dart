import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class MultiTodoProvider with ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => _todos;

  void add(String title) {
    if (title.isNotEmpty) {
      _todos.add(title);
      notifyListeners();
    }
  }
}

class MultiSetup {
  static final providers = [
    ChangeNotifierProvider(create: (_) => MultiTodoProvider()),
  ];
}
