import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/multiprovider_setup.dart';
import '../widgets/navigation.dart';

class MultiProviderPage extends StatelessWidget {
  const MultiProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<MultiTodoProvider>(context);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('MultiProvider')),
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
              itemBuilder: (_, i) => ListTile(
                title: Text(todoProvider.todos[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
