import '../domain/models/task_status.dart';
import 'enums.dart';

extension CustomDateFormatter on DateTime {
  /// Returns format: "January 25, 2026 || 06:30 PM"
  String toCustomFormat() {
    // 1. Month Names Map

    // 2. Handle 12-hour format logic
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12; // Handle Midnight/Noon as 12

    final String period = hour < 12 ? 'AM' : 'PM';

    // 3. Pad single digits (e.g., 9 -> 09)
    final String dayStr = day.toString().padLeft(2, '0');
    final String hourStr = hour12.toString().padLeft(2, '0');
    final String minuteStr = minute.toString().padLeft(2, '0');

    // 4. Assemble the final String
    return "${months[month - 1]} $dayStr, $year || $hourStr:$minuteStr $period";
  }
}

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];


extension TaskStatusSortForm on TaskStatus {
  String get short {
    switch (this) {
      case TaskStatus.todo: return  "TD";
      case TaskStatus.inProgress: return  "WIP";
      case TaskStatus.stuck: return  "ST";
      case TaskStatus.completed: return  "CM";
     
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}