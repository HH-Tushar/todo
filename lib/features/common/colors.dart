import 'dart:ui';

import '../domain/models/task_status.dart';

 const highPriority = Color(0xff8B0000);
 const baseBlack =  Color.fromARGB(255, 56, 56, 56);
// const modaratePriority = Color(0xff5A1A1A);
// const lowPriority = Color(0xff2A2A5A);

// ///
// ///task type color code
// ///
// const personalTaskType = Color(0xffE0F7F4);
// const familylTaskType = Color(0xffFFF0D4);
// const officeTaskType = Color(0xffE8F19A);
// const eduTaskType = Color(0xffD4E9FF);









extension TaskPriorityColor on TaskPriority {
  Color get backgroundColor {
    switch (this) {
      case TaskPriority.high: return const Color(0xFFFFD4D4);
      case TaskPriority.moderate: return const Color(0xFFF19A9A);
      case TaskPriority.low: return const Color(0xFFD4D4FF);
    }
  }

  Color get textColor {
    switch (this) {
      case TaskPriority.high: return const Color(0xFF8B0000);
      case TaskPriority.moderate: return const Color(0xFF5A1A1A);
      case TaskPriority.low: return const Color(0xFF2A2A5A);
    }
  }
}

extension TaskTypeColor on TaskType {
  Color get color {
    switch (this) {
      case TaskType.personal: return const Color(0xFFE0F7F4);
      case TaskType.family: return const Color(0xFFFFF0D4);
      case TaskType.office: return const Color(0xFFE8F19A);
      case TaskType.edu: return const Color(0xFFD4E9FF);
    }
  }
}