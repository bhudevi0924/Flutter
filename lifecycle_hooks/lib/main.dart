import 'package:flutter/material.dart';
import 'package:lifecycle_hooks/hook_widget_lifecycle_hooks.dart';
import 'package:lifecycle_hooks/stateful_widget_lifecycle_hooks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lifecycle Hooks Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/stateful': (context) => StatefulWidgetLifecycleHooks(),
        '/hook': (context) => HookWidgetLifecycleHooks(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lifecycle Hooks')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/stateful'),
              child: Text('StatefulWidget Lifecycle Hooks',style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/hook'),
              child: Text('HookWidget Lifecycle Hooks',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
