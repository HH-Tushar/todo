import 'package:drift/drift.dart';



import '../../../core/app_local_database.dart';
import '../../common/enums.dart';

class LocalTaskDataSource {
  final AppDatabase _db;

  LocalTaskDataSource(this._db);

  Stream<List<Task>> watchTasks({
    String? searchQuery,
    TaskStatus? filterStatus,
    TaskSortOption sortOption = TaskSortOption.deadlineAsc, // Use Enum!
  }) {
    
    final query = _db.select(_db.tasks);

    // CORRECT WAY: Combine filters using the & operator
    query.where((t) {
      final List<Expression<bool>> predicates = [];

      if (searchQuery != null && searchQuery.isNotEmpty) {
        predicates.add(t.title.contains(searchQuery));
      }

      if (filterStatus != null) {
        predicates.add(t.status.equals(filterStatus.index));
      }

      // Join all predicates with AND logic
      return predicates.isEmpty
          ? const Constant(true)
          : predicates.reduce((value, element) => value & element);
    });

    // Type-safe Sorting
    query.orderBy([
      (t) {
        switch (sortOption) {
          case TaskSortOption.deadlineAsc:
            return OrderingTerm(expression: t.deadline, mode: OrderingMode.asc);
          case TaskSortOption.deadlineDesc:
            return OrderingTerm(
              expression: t.deadline,
              mode: OrderingMode.desc,
            );
          case TaskSortOption.createdAtNewest:
            return OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.desc,
            );
          case TaskSortOption.createdAtOldest:
            return OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.asc,
            );
        }
      },
    ]);

    return query.watch();
  }

  Future<int> insertTask(TasksCompanion task) =>
      _db.into(_db.tasks).insert(task);

  Future<bool> updateTask(Task task) => _db.update(_db.tasks).replace(task);

  Future<int> deleteTask(int id) =>
      (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();

  Future<Task?> getTaskById(int id) =>
      (_db.select(_db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  @override
  Stream<List<Task>> watchTasksByStatus(
    TaskStatus status, {
    TaskSortOption sortOption = TaskSortOption.deadlineAsc, // Default
  }) {
    final query = _db.select(_db.tasks)
      ..where((t) => t.status.equals(status.index));

    // The switch case to determine the sorting logic
    query.orderBy([
      (t) {
        switch (sortOption) {
          case TaskSortOption.deadlineAsc:
            return OrderingTerm(expression: t.deadline, mode: OrderingMode.asc);
          case TaskSortOption.deadlineDesc:
            return OrderingTerm(
              expression: t.deadline,
              mode: OrderingMode.desc,
            );
          case TaskSortOption.createdAtNewest:
            return OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.desc,
            );
          case TaskSortOption.createdAtOldest:
            return OrderingTerm(
              expression: t.createdAt,
              mode: OrderingMode.asc,
            );
        }
      },
    ]);

    return query.watch();
  }
}
