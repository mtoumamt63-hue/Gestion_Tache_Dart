import 'package:gestion_tache_dart/models/tache_urgente.dart';
import 'package:gestion_tache_dart/repositories/tache_repository.dart';
import 'package:gestion_tache_dart/storage/json_storage.dart';

void main() async {
  final storage = JsonStorage('data/tasks.json');

  final repository = TaskRepository(storage);

  final task = UrgentTask(id: '1', title: 'Terminer le projet Dart');

  await repository.add(task);

  final tasks = await repository.getAll();

  for (final task in tasks) {
    print('${task.id} - ${task.title}');
  }
}
