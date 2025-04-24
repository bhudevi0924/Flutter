import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/proxy_provider.dart';
import '../widgets/navigation.dart';

class ProxyProviderPage extends StatelessWidget {
  const ProxyProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final proxyProvider = Provider.of<ProxyTodoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ProxyProvider')),
      drawer: const NavigationDrawerWidget(),
      body: Column(
        children: [
          Text('User: ${proxyProvider.user}'),
          Expanded(
            child: ListView.builder(
              itemCount: proxyProvider.todos.length,
              itemBuilder: (_, i) => ListTile(title: Text(proxyProvider.todos[i])),
            ),
          ),
        ],
      ),
    );
  }
}
