import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/init.dart';

import '../../domain/models/task_model.dart';
import '../../domain/models/task_status.dart';

part 'task_state.dart';
/// 1. The Filter Provider
/// Holds the current Search, Sort, and Status filter.
final taskFilterProvider = StateProvider<TaskFilterState>((ref) => const TaskFilterState());

/// 2. The Task List Stream Provider
/// This automatically re-runs whenever the `taskFilterProvider` changes.
final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final filters = ref.watch(taskFilterProvider);

  return repository.watchTasks(
    searchQuery: filters.searchQuery,
    filterStatus: filters.filterStatus,
    sortBy: filters.sortBy,
  );
});

/// 3. The Task Action Notifier
/// Handles Create, Update, and Delete operations.
final taskActionProvider = Provider((ref) => TaskActions(ref));

class TaskActions {
  final Ref _ref;
  TaskActions(this._ref);

  Future<void> addTask({
    required String title,
    required DateTime deadline,
    String type = 'Personal',
  }) async {
    final repo = _ref.read(taskRepositoryProvider);
    await repo.createTask(
      TasksCompanion.insert(
        title: title,
        deadline: deadline,
        status: TaskStatus.todo,
        taskType: Value(type), 
        description: Value("value 3428342342 42 342 34 $title")

      ),
    );
  }

  Future<void> toggleStatus(Task task) async {
    final repo = _ref.read(taskRepositoryProvider);
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.todo 
        : TaskStatus.completed;
    
    await repo.updateTask(task.copyWith(status: newStatus));
  }

  Future<void> removeTask(int id) async {
    await _ref.read(taskRepositoryProvider).deleteTask(id);
  }

  // Helper to update filters from the UI
  void updateSearch(String query) {
    _ref.read(taskFilterProvider.notifier).update((s) => s.copyWith(searchQuery: query));
  }

  void updateSort(String sortBy) {
    _ref.read(taskFilterProvider.notifier).update((s) => s.copyWith(sortBy: sortBy));
  }
}

