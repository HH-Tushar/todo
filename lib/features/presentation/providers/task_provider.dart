import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_local_database.dart';
import '../../../core/init.dart';

import '../../common/enums.dart';


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

///
/// 3. The Task Action Notifier
/// Handles Create, Update, and Delete operations.
///

///
/// The Provider
///

class TaskDraftController extends StateNotifier<TaskDraftState> {
  final Ref _ref;

  TaskDraftController(this._ref) : super(TaskDraftState.initial());

  // --- 1. Lifecycle Actions ---

  /// Loads an existing task into the state. Use this before navigating to Edit Page.
  Future<void> loadTask(int taskId) async {
    final task = await _ref.read(taskRepositoryProvider).getTaskById(taskId);
    if (task != null) {
      state = TaskDraftState.fromTask(task);
    }
  }

  void reset() => state = TaskDraftState.initial();

  // --- 2. Database Actions (Merged from TaskActions) ---

  Future<void> save(BuildContext context) async {
    final repo = _ref.read(taskRepositoryProvider);
    state = state.copyWith(isLoading: true);
    try {
      if (state.isEditing) {
        await repo.updateTask(state.daringToTask());
      } else {
        await repo.createTask(state.toCompanion());
        reset();
      }
      state = state.copyWith(isLoading: false);
      if (context.mounted) Navigator.pop(context);
      // Always clear after a successful save
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> removeActiveTask(int id) async {
    // if (state.id == null) return;
    await _ref.read(taskRepositoryProvider).deleteTask(id);
    // reset();
  }

  // --- 3. Field Updates ---

  void update(TaskDraftState Function(TaskDraftState) updater) {
    state = updater(state);
  }
}

// The Final Provider
final taskDraftControllerProvider =
    StateNotifierProvider<TaskDraftController, TaskDraftState>((ref) {
      return TaskDraftController(ref);
    });
