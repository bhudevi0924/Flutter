class Todo {
  final int? id;
  final String task;
  final String status;

  Todo({
    this.id,
    required this.task,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'status': status,
    };
  }
}
