import '../exceptions/task_exception.dart';
import '../models/tache.dart';
import '../models/tache_normale.dart';
import '../models/tache_urgente.dart';
import '../repositories/repository.dart';
import '../utils/priority.dart';

class TaskService {
  final Repository<Task> repository;

  TaskService(this.repository);

  Future<Task> addTask({
    required String title,
    required Priority priority,
    DateTime? dueDate,
    bool urgent = false,
  }) async {
    if (title.trim().isEmpty) {
      throw TaskException('Le titre de la tâche ne peut pas être vide.');
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    late final Task task;

    if (urgent) {
      task = UrgentTask(id: id, title: title.trim(), dueDate: dueDate);
    } else {
      task = NormalTask(
        id: id,
        title: title.trim(),
        priority: priority,
        dueDate: dueDate,
      );
    }

    await repository.add(task);

    return task;
  }

  Future<List<Task>> getTasks() async {
    return await repository.getAll();
  }

  Future<List<Task>> getTasksSortedByPriority() async {
    final tasks = List<Task>.from(await repository.getAll());

    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return tasks;
  }

  Future<List<Task>> getTasksSortedByDueDate() async {
    final tasks = List<Task>.from(await repository.getAll());

    tasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) {
        return 0;
      }

      if (a.dueDate == null) {
        return 1;
      }

      if (b.dueDate == null) {
        return -1;
      }

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return tasks;
  }

  Future<void> completeTask(String id) async {
    final tasks = await repository.getAll();

    Task? foundTask;

    for (final task in tasks) {
      if (task.id == id) {
        foundTask = task;
        break;
      }
    }

    if (foundTask == null) {
      throw TaskException('Tâche introuvable.');
    }

    foundTask.complete();

    await repository.update(foundTask);
  }

  Future<void> deleteTask(String id) async {
    final tasks = await repository.getAll();

    final exists = tasks.any((task) => task.id == id);

    if (!exists) {
      throw TaskException('Tâche introuvable.');
    }

    await repository.delete(id);
  }
}
