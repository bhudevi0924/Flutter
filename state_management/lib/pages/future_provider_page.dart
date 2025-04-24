import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation.dart';

class FutureProviderPage extends StatelessWidget {
  const FutureProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<String>>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('FutureProvider')),
      drawer: const NavigationDrawerWidget(),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, i) => ListTile(title: Text(todos[i])),
      ),
    );
  }
}
