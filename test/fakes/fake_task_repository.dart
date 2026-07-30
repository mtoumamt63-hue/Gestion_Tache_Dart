import 'package:gestion_tache_dart/models/tache.dart';
import 'package:gestion_tache_dart/repositories/repository.dart';

class FakeTaskRepository implements Repository<Task> {
  final List<Task> tasks = [];

  @override
  Future<void> add(Task item) async {
    tasks.add(item);
  }

  @override
  Future<List<Task>> getAll() async {
    return List.unmodifiable(tasks);
  }

  @override
  Future<void> update(Task item) async {
    final index = tasks.indexWhere((task) => task.id == item.id);

    if (index != -1) {
      tasks[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    tasks.removeWhere((task) => task.id == id);
  }
}
