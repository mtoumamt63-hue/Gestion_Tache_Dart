import 'tache.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
    super.completed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'type': 'normal',
    };
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    title = json['title'] as String;
    completed = json['completed'] as bool;
  }
}
