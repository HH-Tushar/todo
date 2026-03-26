part of 'task_provider.dart';




class TaskFilterState {
  final String searchQuery;
  final TaskStatus? filterStatus;
  final String sortBy;

  const TaskFilterState({
    this.searchQuery = '',
    this.filterStatus,
    this.sortBy = 'deadline',
  });

  TaskFilterState copyWith({
    String? searchQuery,
    TaskStatus? filterStatus,
    String? sortBy,
  }) {
    return TaskFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// The state object
class TaskDraftState {
  final String title;
  final String description;
  final DateTime deadline;
  final TaskType taskType;
  final TaskStatus taskStatus;
  final bool hasReminder;

  TaskDraftState({
    required this.title,
    required this.description,
    required this.deadline,
    required this.taskType,
    required this.hasReminder,
    required this.taskStatus,
  });

  TaskDraftState copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    TaskType? taskType,
    TaskStatus? taskStatus,
    bool? hasReminder,
  }) {
    return TaskDraftState(
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      taskType: taskType ?? this.taskType,
      hasReminder: hasReminder ?? this.hasReminder,
      taskStatus: taskStatus ?? this.taskStatus,
    );
  }
}

