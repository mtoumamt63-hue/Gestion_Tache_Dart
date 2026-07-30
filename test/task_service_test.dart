import 'package:test/test.dart';

import 'package:gestion_tache_dart/exceptions/task_exception.dart';
import 'package:gestion_tache_dart/models/tache_urgente.dart';
import 'package:gestion_tache_dart/services/task_service.dart';
import 'package:gestion_tache_dart/utils/priority.dart';

import 'fakes/fake_task_repository.dart';

void main() {
  late FakeTaskRepository repository;
  late TaskService service;

  setUp(() {
    repository = FakeTaskRepository();
    service = TaskService(repository);
  });

  test('ajoute correctement une tâche', () async {
    final task = await service.addTask(
      title: 'Apprendre Dart',
      priority: Priority.medium,
    );

    expect(repository.tasks.length, 1);
    expect(task.title, 'Apprendre Dart');
    expect(task.priority, Priority.medium);
  });

  test('refuse une tâche avec un titre vide', () async {
    expect(
      () => service.addTask(title: '', priority: Priority.medium),
      throwsA(isA<TaskException>()),
    );
  });

  test('crée une tâche urgente lorsqu urgent vaut true', () async {
    final task = await service.addTask(
      title: 'Corriger le projet',
      priority: Priority.high,
      urgent: true,
    );

    expect(task, isA<UrgentTask>());
    expect(task.priority, Priority.high);
  });

  test('marque une tâche comme terminée', () async {
    final task = await service.addTask(
      title: 'Tester le service',
      priority: Priority.low,
    );

    expect(task.completed, false);

    await service.completeTask(task.id);

    expect(repository.tasks.first.completed, true);
  });
  test('trie les tâches par priorité décroissante', () async {
    await service.addTask(title: 'Tâche faible', priority: Priority.low);

    await service.addTask(title: 'Tâche haute', priority: Priority.high);

    await service.addTask(title: 'Tâche moyenne', priority: Priority.medium);

    final tasks = await service.getTasksSortedByPriority();

    expect(tasks[0].priority, Priority.high);
    expect(tasks[1].priority, Priority.medium);
    expect(tasks[2].priority, Priority.low);
  });

  test('trie les tâches par date limite', () async {
    final date1 = DateTime(2026, 8, 10);
    final date2 = DateTime(2026, 8, 1);
    final date3 = DateTime(2026, 8, 5);

    await service.addTask(
      title: 'Tâche 10 août',
      priority: Priority.medium,
      dueDate: date1,
    );

    await service.addTask(
      title: 'Tâche 1 août',
      priority: Priority.medium,
      dueDate: date2,
    );

    await service.addTask(
      title: 'Tâche 5 août',
      priority: Priority.medium,
      dueDate: date3,
    );

    final tasks = await service.getTasksSortedByDueDate();

    expect(tasks[0].dueDate, date2);
    expect(tasks[1].dueDate, date3);
    expect(tasks[2].dueDate, date1);
  });

  test('supprime une tâche', () async {
    final task = await service.addTask(
      title: 'Tâche à supprimer',
      priority: Priority.low,
    );

    expect(repository.tasks.length, 1);

    await service.deleteTask(task.id);

    expect(repository.tasks, isEmpty);
  });
}
