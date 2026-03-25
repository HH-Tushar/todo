import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/init.dart';

import '../../domain/models/task_model.dart';
import '../../domain/models/task_status.dart';

part 'task_state.dart';

/// 1. The Filter Provider
/// Holds the current Search, Sort, and Status filter.
final taskFilterProvider = StateProvider<TaskFilterState>(
  (ref) => const TaskFilterState(),
);

/// 2. The Task List Stream Provider
/// This automatically re-runs whenever the `taskFilterProvider` changes.
final searchTasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final filters = ref.watch(taskFilterProvider);

  return repository.watchTasks(
    searchQuery: filters.searchQuery,
    filterStatus: filters.filterStatus,
    sortBy: TaskSortOption.createdAtNewest,
  );
});

/// The main stream that gets everything from the DB
// final allTasksProvider = StreamProvider<List<Task>>((ref) {
//   return ref
//       .watch(taskRepositoryProvider)
//       .watchTasks(
//         sortBy: TaskSortOption.createdAtNewest,
//         filterStatus: TaskStatus.completed,
//       );
// });

// This keeps track of which segment the user is looking at
final selectedSegmentProvider = StateProvider<TaskStatus>(
  (ref) => TaskStatus.todo,
);

/// This provider tells the UI *which* status provider to watch
final activeStatusProvider = Provider<StreamProvider<List<Task>>>((ref) {
  final selectedTab = ref.watch(selectedSegmentProvider);

  switch (selectedTab) {
    case TaskStatus.todo:
      return todoTasksProvider;
    case TaskStatus.inProgress:
      return inProgressTasksProvider;
    case TaskStatus.stuck:
      return stuckTasksProvider;
    case TaskStatus.completed:
      return completedTasksProvider;
  }
});

///
///new independent providers based on status
///
final todoTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref
      .watch(taskRepositoryProvider)
      .watchTasks(
        sortBy: TaskSortOption.createdAtNewest,
        filterStatus: TaskStatus.todo,
      );
});
final inProgressTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref
      .watch(taskRepositoryProvider)
      .watchTasks(
        sortBy: TaskSortOption.createdAtNewest,
        filterStatus: TaskStatus.inProgress,
      );
});
final stuckTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref
      .watch(taskRepositoryProvider)
      .watchTasks(
        sortBy: TaskSortOption.createdAtNewest,
        filterStatus: TaskStatus.stuck,
      );
});
final completedTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref
      .watch(taskRepositoryProvider)
      .watchTasks(
        sortBy: TaskSortOption.createdAtNewest,
        filterStatus: TaskStatus.completed,
      );
});

/// Filtered Provider: Todo
/// old one's
// final todoTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
//   return ref
//       .watch(allTasksProvider)
//       .whenData(
//         (tasks) => tasks.where((t) => t.status == TaskStatus.todo).toList(),
//       );
// });

/// Filtered Provider: In Progress
// final inProgressTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
//   return ref
//       .watch(allTasksProvider)
//       .whenData(
//         (tasks) =>
//             tasks.where((t) => t.status == TaskStatus.inProgress).toList(),
//       );
// });

// /// Filtered Provider: Stuck
// final stuckTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
//   return ref
//       .watch(allTasksProvider)
//       .whenData(
//         (tasks) => tasks.where((t) => t.status == TaskStatus.stuck).toList(),
//       );
// });

// /// Filtered Provider: Completed
// final completedTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
//   return ref
//       .watch(allTasksProvider)
//       .whenData(
//         (tasks) =>
//             tasks.where((t) => t.status == TaskStatus.completed).toList(),
//       );
// });

///
/// 3. The Task Action Notifier
/// Handles Create, Update, and Delete operations.
///
final taskActionProvider = Provider((ref) => TaskActions(ref));

///
/// The Provider
///

final taskDraftProvider = StateProvider<TaskDraftState>(
  (ref) => TaskDraftState(
    title: '',
    description: '',
    deadline: DateTime.now().add(const Duration(hours: 1)),
    taskType: TaskType.personal,
    hasReminder: false,
  ),
);

///
///action start here
///

class TaskActions {
  final Ref _ref;
  TaskActions(this._ref);
  final formKey = GlobalKey<FormState>();
  Future<void> addTask(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;
    final repo = _ref.read(taskRepositoryProvider);
    final draft = _ref.read(taskDraftProvider);
    await repo.createTask(
      TasksCompanion.insert(
        title: draft.title,
        deadline: draft.deadline,
        status: TaskStatus.todo,
        taskType: draft.taskType,
        description: Value(draft.description),
        taskPriority: TaskPriority.modarate,
        hasReminder: Value(draft.hasReminder),
        // lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
      ),
    );
    formKey.currentState?.reset();
    if (context.mounted) {
      Navigator.pop(context);
    }
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
    _ref
        .read(taskFilterProvider.notifier)
        .update((s) => s.copyWith(searchQuery: query));
  }

  void updateSort(String sortBy) {
    _ref
        .read(taskFilterProvider.notifier)
        .update((s) => s.copyWith(sortBy: sortBy));
  }
}
