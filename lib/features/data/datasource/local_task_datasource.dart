import 'package:drift/drift.dart';

import '../../domain/models/task_model.dart';
import '../../domain/models/task_status.dart';

class LocalTaskDataSource {
  final AppDatabase _db;

  LocalTaskDataSource(this._db);

  /// The single source of truth for querying the database
  Stream<List<Task>> watchTasks({
    String? searchQuery,
    TaskStatus? filterStatus,
    String sortBy = 'deadline',
  }) {
    final query = _db.select(_db.tasks);

    // Filtering
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where((t) => 
        t.title.contains(searchQuery) | 
        t.taskType.contains(searchQuery)
      );
    }

    if (filterStatus != null) {
      query.where((t) => t.status.equals(filterStatus.index));
    }

    // Sorting
    query.orderBy([
      (t) {
        switch (sortBy) {
          case 'title': return OrderingTerm(expression: t.title);
          case 'status': return OrderingTerm(expression: t.status);
          default: return OrderingTerm(expression: t.deadline);
        }
      }
    ]);

    return query.watch();
  }

  Future<int> insertTask(TasksCompanion task) => _db.into(_db.tasks).insert(task);
  
  Future<bool> updateTask(Task task) => _db.update(_db.tasks).replace(task);
  
  Future<int> deleteTask(int id) => 
      (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  
  Future<Task?> getTaskById(int id) => 
      (_db.select(_db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
}