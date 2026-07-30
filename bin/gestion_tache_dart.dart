import 'package:gestion_tache_dart/models/tache_urgente.dart';

void main() {
  final task = UrgentTask(id: '1', title: 'Terminer projet Dart');

  print(task.title);
  print(task.priority);
}
