import 'package:gestion_tache_dart/cli/task_cli.dart';
import 'package:gestion_tache_dart/repositories/tache_repository.dart';
import 'package:gestion_tache_dart/services/task_service.dart';
import 'package:gestion_tache_dart/storage/json_storage.dart';

Future<void> main() async {
  final storage = JsonStorage('data/tasks.json');

  final repository = TaskRepository(storage);

  final service = TaskService(repository);

  final cli = TaskCli(service);

  await cli.start();
}
