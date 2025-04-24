class FutureTodoProvider {
  Future<List<String>> fetchTodos() async {
    await Future.delayed(const Duration(seconds: 2));
    return ['todo 1', 'todo 2', 'todo3'];
  }
}
