class UserProvider {
  String get userName => "Bhudevi Dobbala";
}

class ProxyTodoProvider {
  final String user;
  List<String> get todos => ['Welcome $user', 'Complete ProxyProvider task!'];

  ProxyTodoProvider(this.user);
}
