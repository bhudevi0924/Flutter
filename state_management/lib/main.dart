import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/basic_provider.dart';
import 'providers/future_provider.dart';
import 'providers/stream_provider.dart';
import 'providers/proxy_provider.dart';
import 'providers/multiprovider_setup.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BasicTodoProvider()),
        FutureProvider<List<String>>(
          create: (_) => FutureTodoProvider().fetchTodos(),
          initialData: [],
        ),
        StreamProvider<List<String>>(
          create: (_) => StreamTodoProvider().streamTodos(),
          initialData: [],
        ),
        Provider(create: (_) => UserProvider()),
        ProxyProvider<UserProvider, ProxyTodoProvider>(
          update: (_, userProvider, __) =>
              ProxyTodoProvider(userProvider.userName),
        ),
        ...MultiSetup.providers,
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App - Providers',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
