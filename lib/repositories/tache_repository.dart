import '../models/tache.dart';
import '../models/tache_normale.dart';
import '../models/tache_urgente.dart';
import '../storage/json_storage.dart';
import '../utils/priority.dart';
import 'repository.dart';

class TaskRepository implements Repository<Task> {
  final JsonStorage storage;

  final List<Task> _tasks = [];

  TaskRepository(this.storage);

  @override
  Future<void> add(Task item) async {
    _tasks.add(item);

    await _save();
  }

  @override
  Future<List<Task>> getAll() async {
    await _load();

    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> delete(String id) async {
    _tasks.removeWhere((task) => task.id == id);

    await _save();
  }

  @override
  Future<void> update(Task item) async {
    final index = _tasks.indexWhere((task) => task.id == item.id);

    if (index == -1) {
      return;
    }

    _tasks[index] = item;

    await _save();
  }

  Future<void> _load() async {
    _tasks.clear();

    final data = await storage.read();

    for (final json in data) {
      final task = _taskFromJson(json);

      _tasks.add(task);
    }
  }

  Future<void> _save() async {
    final data = _tasks.map((task) => task.toJson()).toList();

    await storage.write(data);
  }

  Task _taskFromJson(Map<String, dynamic> json) {
    final type = json['type'];

    if (type == 'urgent') {
      return _createUrgentTask(json);
    }

    return _createNormalTask(json);
  }

  Task _createUrgentTask(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: _parseDate(json['dueDate']),
      completed: json['completed'] as bool? ?? false,
    );
  }

  Task _createNormalTask(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: _parsePriority(json['priority']),
      dueDate: _parseDate(json['dueDate']),
      completed: json['completed'] as bool? ?? false,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value as String);
  }

  Priority _parsePriority(dynamic value) {
    switch (value) {
      case 'low':
        return Priority.low;

      case 'high':
        return Priority.high;

      default:
        return Priority.medium;
    }
  }
}
