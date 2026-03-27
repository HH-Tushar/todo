import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_today/features/common/colors.dart';
import 'package:task_today/features/common/formater.dart';
import 'package:utills/utills.dart';

import '../../../../domain/models/task_model.dart';

class CustomTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  const CustomTaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priority = task.taskPriority;
    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: ValueKey(task.id),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // SlidableAction(
            //   onPressed: (_) => onDelete(),
            //   backgroundColor: const Color.fromARGB(255, 35, 34, 34),
            //   foregroundColor: Colors.red,
            //   icon: Icons.delete,
            //   label: 'Delete',
            // ),
            hPad30,
            FilledButton(
              style: FilledButton.styleFrom(
                fixedSize: Size(100, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onDelete,
              child: Icon(Icons.delete_forever, color: highPriority, size: 30),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: baseBlack,
            borderRadius: BorderRadius.circular(16),
          ),
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
      ),
    );
  }
}
