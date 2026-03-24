// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/task_provider.dart';
// import 'task_card.dart';

// class HomeView extends ConsumerWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // In your Widget build:
//     final taskListAsync = ref.watch(allTasksProvider);

//     return taskListAsync.when(
//       data: (tasks) => ListView.builder(
//         itemCount: tasks.length,
//         itemBuilder: (context, index) => TaskCard(
//           task: tasks[index],
//           onDelete: () =>
//               ref.read(taskActionProvider).removeTask(tasks[index].id),
//           onToggleStatus: () {},
//         ),
//       ),
//       loading: () => CircularProgressIndicator(),
//       error: (err, stack) => Text('Error: $err'),
//     );
//   }
// }
