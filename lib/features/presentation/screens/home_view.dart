import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In your Widget build:
    final taskListAsync = ref.watch(tasksStreamProvider);

    return taskListAsync.when(
      data: (tasks) => ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(tasks[index].title),
          subtitle: Text(tasks[index].description),
          trailing: IconButton(
            onPressed: () =>
                ref.read(taskActionProvider).removeTask(tasks[index].id),
            icon: Icon(Icons.delete),
          ),
          // onTrailing: IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () =>
          //       ref.read(taskActionProvider).removeTask(tasks[index].id),
          // ),
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
