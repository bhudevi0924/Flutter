class StreamTodoProvider {
  Stream<List<String>> streamTodos() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield ['Task one'];
    await Future.delayed(const Duration(seconds: 2));
    yield ['Task one', 'Task two'];
    await Future.delayed(const Duration(seconds: 2));
    yield ['Task one', 'Task two', 'Task three'];
  }
}
