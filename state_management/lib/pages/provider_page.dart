import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/basic_provider.dart';
import '../widgets/navigation.dart';

class ProviderPage extends StatelessWidget {
  const ProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<BasicTodoProvider>(context);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Basic Provider')),
      drawer: const NavigationDrawerWidget(),
      body: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () {
              todoProvider.add(controller.text);
              controller.clear();
            },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (_, i) {
                final todo = todoProvider.todos[i];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => todoProvider.toggle(i),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
