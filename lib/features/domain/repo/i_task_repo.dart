import '../../../core/app_local_database.dart';
import '../../common/enums.dart';

import '../models/task_status.dart';

abstract class ITaskRepository {
  // Watch tasks with real-time updates from Isar
  Stream<List<Task>> watchTasks({
    String? searchQuery,
    TaskStatus? filterStatus,
    required TaskSortOption sortBy,
  });
  Future<int> createTask(TasksCompanion task);
  Future<bool> updateTask(Task task);
  Future<int> deleteTask(int id);
  Future<Task?> getTaskById(int id);
  // Stream<Task?> watchTaskById(int id);
}
