import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDetailsView extends ConsumerWidget {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details".toUpperCase())),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: task.taskType.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.taskType.name.capitalize(),
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: task.taskPriority.backgroundColor,
                          // color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.taskPriority.name.capitalize(),
                          style: TextStyle(
                            color: task.taskPriority.textColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (task.hasReminder)
                  const Icon(Icons.alarm, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date: ${task.deadline.toCustomFormat()}',
                  style: TextStyle(color: Colors.grey),
                ),
                // Simple Avatars Placeholder
                SizedBox(
                  width: 40,
                  height: 24,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blueGrey.shade800,
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.brown.shade400,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            task.status.short,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
