import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class AddTaskView extends ConsumerWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Standard Flutter controllers (Senior Tip: In a real Stateless widget, 
    // these are often passed in or managed by a specialized provider, 
    // but for a simple Add view, local controllers are fine).
    final titleController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'N E W  T A S K',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Enter task title...',
            hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onSubmitted: (value) => _handleSave(context, ref, titleController),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            // Tactical "Quick Add" Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_today, size: 14),
                  SizedBox(width: 6),
                  Text('Tomorrow', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const Spacer(),
            // Save Button using our taskActionProvider
            FloatingActionButton.extended(
              elevation: 0,
              onPressed: () => _handleSave(context, ref, titleController),
              label: const Text('SAVE TASK'),
              icon: const Icon(Icons.add_task),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSave(BuildContext context, WidgetRef ref, TextEditingController controller) {
    final title = controller.text.trim();
    if (title.isNotEmpty) {
      // Using the Action Provider from the previous step
      ref.read(taskActionProvider).addTask(
            title: title,
            deadline: DateTime.now().add(const Duration(days: 1)),
            type: 'Personal',
          );
      // Navigator.pop(context);
    }
  }
}