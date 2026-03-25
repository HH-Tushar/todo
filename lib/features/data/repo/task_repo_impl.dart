import '../../domain/models/task_model.dart';
import '../../domain/models/task_status.dart';
import '../../domain/repo/i_task_repo.dart';
import '../datasource/local_task_datasource.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final LocalTaskDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);
  @override
  Stream<List<Task>> watchTasks({
    String? searchQuery,
    TaskStatus? filterStatus,
   required TaskSortOption sortBy

  }) {
    return _localDataSource.watchTasks(
      searchQuery: searchQuery,
      filterStatus: filterStatus,
      sortOption: sortBy,
    );
  }

 

  @override
  Future<int> createTask(TasksCompanion task) {
    return _localDataSource.insertTask(task);
  }

  @override
  Future<bool> updateTask(Task task) {
    return _localDataSource.updateTask(task);
  }

  @override
  Future<int> deleteTask(int id) {
    return _localDataSource.deleteTask(id);
  }

  @override
  Future<Task?> getTaskById(int id) {
    return _localDataSource.getTaskById(id);
  }
}
