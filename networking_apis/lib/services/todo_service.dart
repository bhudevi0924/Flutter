import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/todo.dart';

class TodoService {
  // final String baseUrl = 'http://localhost:8080';
  final Dio _dio;
  TodoService() : _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080')) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Pre-interceptor
          print("pre");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print("post");
          }
          // Post-interceptor
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("error");
          // Error interceptor
          return handler.next(e);
        },
      ),
    );
  }
  

  Future<List<Todo>> fetchTodos() async {
    //http call
    // final response = await http.get(Uri.parse('$baseUrl/GetTodoList'));
    // if (response.statusCode == 200) {
    //   final List data = jsonDecode(response.body);
    //   return data.map((e) => Todo.fromJson(e)).toList();
    // } else {
    //   throw Exception('Failed to load todos');
    // }

     try {
      final response = await _dio.get('/GetTodoList');
      final List data = response.data;
      return data.map((e) => Todo.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load todos: ${e.message}');
    }
  }

  Future<void> createTodo(Todo todo) async {
    try{
        // await http.post(
        //   Uri.parse('$baseUrl/CreateToDo'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: jsonEncode(todo.toJson()),
        // );
       await _dio.post(
        '/CreateToDo',
        data: todo.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch(e){
      throw Exception('Failed to create todo: ${e.message}');
    }
  }

  Future<void> updateTodo(int id, Todo todo) async {
    // await http.put(
    //   Uri.parse('$baseUrl/UpdateToDo/$id'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(todo.toJson()),
    // );

    try {
      await _dio.put(
        '/UpdateToDo/$id',
        data: todo.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update todo: ${e.message}');
    }
  }

  Future<void> deleteTodo(int id) async {
    // await http.delete(Uri.parse('$baseUrl/DeleteToDo/$id'));
     try {
      await _dio.delete('/DeleteToDo/$id');
    } on DioException catch (e) {
      throw Exception('Failed to delete todo: ${e.message}');
    }
  }
}
