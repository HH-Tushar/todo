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

class TaskDraftNotifier extends StateNotifier<TaskDraftState> {
  TaskDraftNotifier()
    : super(
        TaskDraftState(
          title: '',
          description: '',
          deadline: DateTime.now().add(const Duration(hours: 1)),
          taskType: TaskType.personal,
          hasReminder: false,
          taskStatus: TaskStatus.todo,
          taskPriority: TaskPriority.moderate,
        ),
      );

  void setFromTask(Task task) {
    state = TaskDraftState(
      title: task.title,
      id: task.id,
      createdAt: task.createdAt,
      isSynced: task.isSynced,
      description: task.description,
      deadline: task.deadline,
      taskType: task.taskType,
      hasReminder: task.hasReminder,
      taskStatus: task.status,
      taskPriority: task.taskPriority,
    );
  }

  void reset() {
    state = TaskDraftState(
      title: '',
      description: '',
      deadline: DateTime.now().add(const Duration(hours: 1)),
      taskType: TaskType.personal,
      hasReminder: false,
      taskStatus: TaskStatus.todo,
      taskPriority: TaskPriority.moderate,
    );
  }

  void update(TaskDraftState Function(TaskDraftState) updater) {
    state = updater(state);
  }
}




final taskDraftProvider =
    StateNotifierProvider<TaskDraftNotifier, TaskDraftState>(
      (ref) => TaskDraftNotifier(),
    );




final taskDetailProvider = FutureProvider.family<Task?, int>((
  ref,
  taskId,
) async {
  final repo = ref.read(taskRepositoryProvider);

  return repo.getTaskById(taskId);
});



///
///action start here
///
final taskActionProvider = Provider((ref) => TaskActions(ref));

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
        status: draft.taskStatus,
        taskType: draft.taskType,
        description: Value(draft.description),
        taskPriority: draft.taskPriority,
        hasReminder: Value(draft.hasReminder),
        // lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
      ),
    );

    _ref.read(taskDraftProvider.notifier).reset();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> updateTask(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;
    final repo = _ref.read(taskRepositoryProvider);
    final draft = _ref.read(taskDraftProvider);
    await repo.updateTask(
      Task(
        id: draft.id!,
        createdAt: draft.createdAt!,
        isSynced: draft.isSynced!,
        lastModified: DateTime.now(),
        title: draft.title,
        description: draft.description,
        deadline: draft.deadline,
        status: draft.taskStatus,
        taskType: draft.taskType,
        hasReminder: draft.hasReminder,
        taskPriority: draft.taskPriority,
      ),
    );
    _ref.read(taskDraftProvider.notifier).reset();
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
