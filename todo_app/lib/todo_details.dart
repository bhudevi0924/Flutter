import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoDetail extends StatelessWidget {
  final Todo todo;

  const TodoDetail({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Todo Detail")), // this can be used to get the back button automatically without writing any button
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            Text("Task:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(todo.text, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            SizedBox(height: 16),
            Text("Completed: ${todo.isDone ? 'Yes' : 'No'}", style: TextStyle(fontStyle: FontStyle.italic),),
          ],
        ),
      ),
    );
  }
}
