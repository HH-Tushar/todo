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