enum TaskStatus { todo, inProgress, stuck, completed }

enum TaskPriority { high, moderate, low }

enum TaskType { personal, family, office, edu }
enum TaskSortOption {
  deadlineAsc,   // Earliest first
  deadlineDesc,  // Latest first
  createdAtNewest,
  createdAtOldest,
}
