import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      drawer: NavigationDrawerWidget(),
      body: Center(child: Text('Select a provider from the drawer')),
    );
  }
}
