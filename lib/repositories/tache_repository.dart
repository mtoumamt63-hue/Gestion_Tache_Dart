import '../models/tache.dart';
import 'repository.dart';

class TaskRepository implements Repository<Task> {
  final List<Task> _tasks = [];

  @override
  Future<void> add(Task item) async {
    _tasks.add(item);
  }

  @override
  Future<List<Task>> getAll() async {
    return _tasks;
  }

  @override
  Future<void> delete(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<void> update(Task item) async {
    final index = _tasks.indexWhere((task) => task.id == item.id);

    if (index != -1) {
      _tasks[index] = item;
    }
  }
}
