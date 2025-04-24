import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:networking_apis/pages/todo_list_page.dart';
import 'pages/user_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() async{
  
  await Hive.initFlutter();
  Box todoBox = await Hive.openBox("todoBox");
  todoBox.put("name","Bhudevi");
  todoBox.put("id",1);

  print('name ${todoBox.get("name")}');
  print('id ${todoBox.get("id")}');
  final storage = FlutterSecureStorage();
  await storage.write(key: 'token', value: 'my_secure_token');
  String? token = await storage.read(key: 'token');
  print("token ${token}");
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Demo')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Navigation Menu'),
            ),
            _navItem(context, "Random user api integration", const UserPage()),
            _navItem(context, "Backend integration (Spring Boot)", const TodoListPage()),
          ],
        ),
      ),
      body: const Center(
        child: Text("Select a page from the drawer."),
      ),
    );
  }

  ListTile _navItem(BuildContext ctx, String title, Widget page) => ListTile(
        title: Text(title),
        onTap: () {
          Navigator.pop(ctx); // Close the drawer first
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      );
}
