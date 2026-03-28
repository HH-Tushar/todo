import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utills/utills.dart';

import '../../common/colors.dart';
import '../../common/formater.dart';
import '../../common/text_style.dart';
import '../providers/task_provider.dart';
import 'add_task_view.dart';

class TaskDetailsView extends ConsumerStatefulWidget {
  const TaskDetailsView({super.key, required this.taskId});
  final int taskId;

  @override
  ConsumerState<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends ConsumerState<TaskDetailsView> {
  @override
  void initState() {
    super.initState();
    // INITIALIZE: Load the task into the controller immediately
    Future.microtask(() {
      ref.read(taskDraftControllerProvider.notifier).loadTask(widget.taskId);
    });
  }
  @override
  Widget build(BuildContext context) {
    // final draft = ref.watch(taskDraftProvider);
    final taskState = ref.watch(taskDraftControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Task Details".toUpperCase())),

      body: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (!taskState.isLoading && taskState.error != null)
          ? Center(child: Text('Error: ${taskState.error}'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title", style: subTitle),
                  vPad5,
                  Text(
                    taskState.title,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  vPad20,
                  Text("Details", style: subTitle), vPad5,
                  Text(
                    taskState.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  vPad35,
                  const Divider(color: Colors.white70, height: 40),
                  vPad20,
                  // Metadata: Type Dropdown
                  _buildActionRow(
                    icon: Icons.tag_outlined,
                    label: 'taskState Status',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: baseBlack,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        taskState.taskStatus.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // final TaskStatus? selectedStatus = await showDialog<TaskStatus>(
                      //   context: context,

                      //   builder: (context) => SimpleDialog(
                      //     backgroundColor: Colors.black87,
                      //     title: const Text(
                      //       'Select Task Status',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     children: TaskStatus.values
                      //         .map(
                      //           (type) => SimpleDialogOption(
                      //             onPressed: () => Navigator.pop(context, type),
                      //             child: Text(
                      //               type.name[0].toUpperCase() +
                      //                   type.name.substring(1),
                      //             ),
                      //           ),
                      //         )
                      //         .toList(),
                      //   ),
                      // );
                      // if (selectedStatus != null) {
                      //   draftController.update(
                      //     (s) => s.copyWith(taskStatus: selectedStatus),
                      //   );
                      // }
                    },
                  ),

                  // Metadata: Type Dropdown
                  _buildActionRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Created At',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: baseBlack,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        taskState.createdAt!.toCustomFormat(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Metadata: Type Dropdown
                  _buildActionRow(
                    icon: Icons.watch_later_outlined,
                    label: 'Dead Line',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: baseBlack,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        taskState.deadline.toCustomFormat(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // final TaskStatus? selectedStatus = await showDialog<TaskStatus>(
                      //   context: context,

                      //   builder: (context) => SimpleDialog(
                      //     backgroundColor: Colors.black87,
                      //     title: const Text(
                      //       'Select Task Status',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     children: TaskStatus.values
                      //         .map(
                      //           (type) => SimpleDialogOption(
                      //             onPressed: () => Navigator.pop(context, type),
                      //             child: Text(
                      //               type.name[0].toUpperCase() +
                      //                   type.name.substring(1),
                      //             ),
                      //           ),
                      //         )
                      //         .toList(),
                      //   ),
                      // );
                      // if (selectedStatus != null) {
                      //   draftController.update(
                      //     (s) => s.copyWith(taskStatus: selectedStatus),
                      //   );
                      // }
                    },
                  ),

                  // Metadata: Reminder Toggle
                  _buildActionRow(
                    icon: Icons.notifications_none_outlined,
                    label: 'Set Reminder',
                    trailing: Switch.adaptive(
                      value: taskState.hasReminder,

                      onChanged: (value) {
                        // draftController.update(
                        //   (s) => s.copyWith(hasReminder: value),
                        // );
                      },
                    ),
                  ),

                  // Metadata: Type Dropdown
                  _buildActionRow(
                    icon: Icons.tag_outlined,
                    label: 'Task Type',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: taskState.taskType.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        taskState.taskType.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // final TaskType? selectedType = await showDialog<TaskType>(
                      //   context: context,

                      //   builder: (context) => SimpleDialog(
                      //     backgroundColor: Colors.black87,
                      //     title: const Text(
                      //       'Select Task Type',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     children: TaskType.values
                      //         .map(
                      //           (type) => SimpleDialogOption(
                      //             onPressed: () => Navigator.pop(context, type),
                      //             child: Text(
                      //               type.name[0].toUpperCase() +
                      //                   type.name.substring(1),
                      //             ),
                      //           ),
                      //         )
                      //         .toList(),
                      //   ),
                      // );
                      // if (selectedType != null) {
                      //   draftController.update(
                      //     (s) => s.copyWith(taskType: selectedType),
                      //   );
                      // }
                    },
                  ),

                  vPad35,
                  vPad35,
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddTaskView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'EDIT TASK',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  vPad35,
                ],
              ),
            ),
    );
  }
}

Widget _buildActionRow({
  required IconData icon,
  required String label,
  required Widget trailing,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    splashColor: baseBlack,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    ),
  );
}
