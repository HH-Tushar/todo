import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utills/utills.dart';

import '../../common/colors.dart';
import '../../common/formater.dart';
import '../../common/text_style.dart';
import '../providers/task_provider.dart';

class TaskDetailsView extends ConsumerWidget {
  const TaskDetailsView({super.key, required this.taskId});
  final int taskId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(taskDraftProvider);
    final taskAsync = ref.watch(taskDetailProvider(taskId));
    return Scaffold(
      appBar: AppBar(title: Text("Task Details".toUpperCase())),

      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text("Task no longer exists."));
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title", style: subTitle),
                Text(task.title,style:  const TextStyle(color: Colors.white70, fontSize: 18),),
                vPad20,
                Text("Details", style: subTitle),
                Text(task.description,style:  const TextStyle(color: Colors.white70, fontSize: 16)),

                vPad15,
 const Divider(color: Colors.white10, height: 40),

                // Metadata: Type Dropdown
                _buildActionRow(
                  icon: Icons.tag_outlined,
                  label: 'Task Status',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      draft.taskStatus.name,
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
                  icon: Icons.watch_later_outlined,
                  label: 'Dead Line',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.deadline.toCustomFormat(),
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
                  value: task.hasReminder,

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
                    color:  task.taskType.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.taskType.name,
                    style:  TextStyle(
                      color:  Colors.black,
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



        ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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
    splashColor: Colors.white10,
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
