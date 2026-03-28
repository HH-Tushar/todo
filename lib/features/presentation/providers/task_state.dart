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
// class TaskDraftState {
//   final int? id;
//   final String title;
//   final String description;
//   final DateTime deadline;
//   final TaskType taskType;
//   final TaskStatus taskStatus;
//   final bool hasReminder;
//   final TaskPriority taskPriority;
//   final DateTime? createdAt;
//   final bool? isSynced;

//   TaskDraftState({
//     required this.title,
//     this.id,
//     this.createdAt,
//     this.isSynced,
//     required this.description,
//     required this.deadline,
//     required this.taskType,
//     required this.hasReminder,
//     required this.taskStatus,
//     required this.taskPriority,
//   });

//   TaskDraftState copyWith({
//     String? title,
//     String? description,
//     DateTime? deadline,
//     TaskType? taskType,
//     TaskStatus? taskStatus,
//     bool? hasReminder,
//     TaskPriority? taskPriority,
//   }) {
//     return TaskDraftState(
//   id: id,
//       createdAt: createdAt,
//       isSynced: isSynced,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       deadline: deadline ?? this.deadline,
//       taskType: taskType ?? this.taskType,
//       hasReminder: hasReminder ?? this.hasReminder,
//       taskStatus: taskStatus ?? this.taskStatus,
//       taskPriority: taskPriority ?? this.taskPriority,
//     );
//   }
// }

class TaskDraftState {
  final bool isLoading;
  final String? error;
  final int? id;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskType taskType;
  final TaskStatus taskStatus;
  final bool hasReminder;
  final TaskPriority taskPriority;
  final DateTime? createdAt;
  final bool? isSynced;

  TaskDraftState({
    this.id,
    this.error,
    this.isLoading = false,
    required this.title,
    required this.description,
    required this.deadline,
    required this.taskType,
    required this.taskStatus,
    required this.hasReminder,
    required this.taskPriority,
    this.createdAt,
    this.isSynced,
  });

  // Check if we are in Edit mode or Add mode
  bool get isEditing => id != null;

  factory TaskDraftState.initial() => TaskDraftState(
    title: '',
    description: '',
    deadline: DateTime.now().add(const Duration(hours: 1)),
    taskType: TaskType.personal,
    hasReminder: false,
    taskStatus: TaskStatus.todo,
    taskPriority: TaskPriority.moderate,
    isLoading: false,
  );

  factory TaskDraftState.fromTask(Task task) => TaskDraftState(
    id: task.id,
    title: task.title,
    description: task.description,
    deadline: task.deadline,
    taskType: task.taskType,
    hasReminder: task.hasReminder,
    taskStatus: task.status,
    taskPriority: task.taskPriority,
    createdAt: task.createdAt,
    isSynced: task.isSynced,
  );

  // Helper for Database Inserts (Drift)
  TasksCompanion toCompanion() => TasksCompanion.insert(
    title: title,
    description: Value(description),
    deadline: deadline,
    taskType: taskType,
    status: taskStatus,
    hasReminder: Value(hasReminder),
    taskPriority: taskPriority,
    createdAt: Value(DateTime.now()),
  );

  // Helper for Database Updates (Drift)
  Task daringToTask() => Task(
    id: id!,
    title: title,
    description: description,
    deadline: deadline,
    taskType: taskType,
    status: taskStatus,
    hasReminder: hasReminder,
    taskPriority: taskPriority,
    createdAt: createdAt!,
    isSynced: isSynced ?? false,
    lastModified: DateTime.now(),
  );

  TaskDraftState copyWith({
    String? title,
    String? error,
    bool? isLoading,
    String? description,
    DateTime? deadline,
    TaskType? taskType,
    TaskStatus? taskStatus,
    bool? hasReminder,
    TaskPriority? taskPriority,
  }) {
    return TaskDraftState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      //
      id: id,
      createdAt: createdAt,
      isSynced: isSynced,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      taskType: taskType ?? this.taskType,
      taskStatus: taskStatus ?? this.taskStatus,
      hasReminder: hasReminder ?? this.hasReminder,
      taskPriority: taskPriority ?? this.taskPriority,
    );
  }
}
