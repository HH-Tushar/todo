import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_today/features/common/formater.dart';
import 'package:utills/utills.dart';
import '../../common/text_style.dart';
import '../../domain/models/task_status.dart';
import '../providers/task_provider.dart';

class AddTaskView extends ConsumerWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the draft state to keep UI reactive
    final draft = ref.watch(taskDraftProvider);
    final draftController = ref.read(taskDraftProvider.notifier);

    final taskController = ref.read(taskActionProvider);
    // Tactical Gold Accent from your Bento Grid
    const primaryGold = Color(0xFFE8F19A);

    return Scaffold(
      appBar: AppBar(title: Text("CREATE TASK")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Form(
          key: taskController.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vPad15,
              // Header Section
              // const Text(
              //   'CREATE TASK',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //   ),
              // ),
              // vPad20,
              // vPad5,

              // Title Input
              Text("Title", style: subTitle),
              vPad5,
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Color.fromARGB(255, 34, 34, 34),
                  filled: true,
                ),

                onChanged: (value) {
                  ref
                      .read(taskDraftProvider.notifier)
                      .update((s) => s.copyWith(title: value));
                },
                validator: CommonValidator.fieldRequired,
              ),
              vPad20,
              // Description Input
              Text("Description", style: subTitle),
              vPad5,
              TextFormField(
                maxLines: 3,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Add description...',
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  fillColor: Color.fromARGB(255, 34, 34, 34),
                  filled: true,
                ),
                onChanged: (value) {
                  ref
                      .read(taskDraftProvider.notifier)
                      .update((s) => s.copyWith(description: value));
                },
                validator: CommonValidator.fieldRequired,
              ),

              const Divider(color: Colors.white10, height: 40),

              // Metadata: Deadline
              _buildActionRow(
                icon: Icons.calendar_today_outlined,
                label: 'Deadline',
                trailing: Text(
                  draft.deadline.toCustomFormat(),
                  style: const TextStyle(
                    color: primaryGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: draft.deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    if (context.mounted) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(draft.deadline),
                      );
                      if (pickedTime == null) return; // User cancelled

                      // 3. Combine them into a single DateTime
                      final DateTime fullDateTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      draftController.update(
                        (s) => s.copyWith(deadline: fullDateTime),
                      );
                    }
                  }
                },
              ),

              // Metadata: Reminder Toggle
              _buildActionRow(
                icon: Icons.notifications_none_outlined,
                label: 'Set Reminder',
                trailing: Switch.adaptive(
                  value: draft.hasReminder,

                  onChanged: (value) {
                    draftController.update(
                      (s) => s.copyWith(hasReminder: value),
                    );
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
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    draft.taskType.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: () async {
                  final TaskType? selectedType = await showDialog<TaskType>(
                    context: context,

                    builder: (context) => SimpleDialog(
                      backgroundColor: Colors.black87,
                      title: const Text(
                        'Select Task Type',
                        style: TextStyle(color: Colors.white),
                      ),
                      children: TaskType.values
                          .map(
                            (type) => SimpleDialogOption(
                              onPressed: () => Navigator.pop(context, type),
                              child: Text(
                                type.name[0].toUpperCase() +
                                    type.name.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                  if (selectedType != null) {
                    draftController.update(
                      (s) => s.copyWith(taskType: selectedType),
                    );
                  }
                },
              ),

              const SizedBox(height: 32),

              // Save Action
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    await taskController.addTask(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'SAVE TASK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for tactical action rows
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
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}
