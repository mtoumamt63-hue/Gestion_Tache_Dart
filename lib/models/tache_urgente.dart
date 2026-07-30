import 'tache.dart';
import '../utils/priority.dart';

class UrgentTask extends Task {
  UrgentTask({required super.id, required super.title, super.dueDate})
    : super(priority: Priority.high);

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "priority": priority.name,
      "dueDate": dueDate?.toIso8601String(),
      "completed": completed,
      "type": "urgent",
    };
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    title = json["title"];

    completed = json["completed"];
  }
}
