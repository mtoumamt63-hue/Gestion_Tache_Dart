import '../lib/models/tache_urgente.dart';
import '../lib/repositories/tache_repository.dart';

void main() async {
  final repository = TaskRepository();

  final task = UrgentTask(id: "1", title: "Apprendre Dart");

  await repository.add(task);

  final tasks = await repository.getAll();

  print(tasks.first.title);
}
