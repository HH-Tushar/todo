import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/task_provider.dart';
import 'components/task_card.dart';

class SegmentedTaskView extends ConsumerWidget {
  const SegmentedTaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the current provider reference (e.g., todoTasksProvider)
    final currentProvider = ref.watch(activeStatusProvider);
    final selectedTab = ref.read(selectedSegmentProvider);

    // 2. Watch the actual data from that provider
    final tasksAsync = ref.watch(currentProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedTab.name.toUpperCase()} Tasks".toUpperCase()),
      ),

      body: tasksAsync.when(
        data: (tasks) => tasks.isEmpty
            ? Center(child: Text("You do not have any ${selectedTab.name} task yet."))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) =>
                    CustomTaskCard(task: tasks[index], onDelete: () {}),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
