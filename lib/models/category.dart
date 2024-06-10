class CategoryTask {
  int? id;
  String name;

  CategoryTask({this.id, required this.name});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory CategoryTask.fromJson(Map<String, dynamic> json) {
    return CategoryTask(
      id: json['id'],
      name: json['name'],
    );
  }
}
