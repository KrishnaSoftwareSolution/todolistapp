class Task {
  int? id;
  String name;
  int? categoryId;
  bool completed;
  DateTime? dueDate;

  Task({
    this.id,
    required this.name,
    required this.categoryId,
    this.completed = false,
    this.dueDate,
  });

  Task copyWith({
    int? id,
    String? name,
    int? categoryId,
    bool? completed,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category_id': categoryId,
        'completed': completed ? 1 : 0,
        'due_date': dueDate!.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      completed: json['completed'] == 1,
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}
