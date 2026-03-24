import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/task_provider.dart';
import 'components/custom_header.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsync = ref.watch(allTasksProvider);

    return CustomScrollView(
      slivers: [
        // 1. Header Section
        const SliverToBoxAdapter(child: _HeaderSection()),

        // 2. Bento Grid (Categories)
        const SliverToBoxAdapter(child: _CategoryGrid()),

        // 3. Ongoing Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ongoing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. Performance Optimized List
        // We handle the AsyncValue here and return a Sliver
        taskListAsync.when(
          data: (tasks) => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              // Only renders items as they enter the viewport
              return CustomTaskCard();
            }, childCount: tasks.length),
          ),
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        // Extra padding at the bottom for the floating button/dock
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }
}

// 4. Ongoing Tasks List
// SliverList(
//   delegate: SliverChildBuilderDelegate(
//     (context, index) => const CustomTaskCard(),
//     childCount: 10, // Matches the screenshot
//   ),
// ),
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Hello ',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Text(
                    'Rakib 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage Your\nDaily Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        spacing: 10,
        children: [
          // Large Mobile Card

          // Two Smaller Stacked Cards
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                _BentoCard(
                  color: const Color(0xFFD4D4FF),

                  icon: Icons.lightbulb_outline,
                  title: 'To Do',
                  taskCount: 12,
                ),

                _BentoCard(
                  color: const Color(0xFFE8F19A),
                  icon: Icons.extension_outlined,
                  title: 'Stuck',
                  taskCount: 5,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                _BentoCard(
                  color: const Color(0xFFE0F7F4),

                  icon: Icons.lightbulb_outline,
                  title: 'In Progess',
                  taskCount: 12,
                ),

                _BentoCard(
                  color: const Color(0xFFE8F19A),
                  icon: Icons.extension_outlined,
                  title: 'Completed',
                  taskCount: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class _BentoCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final int taskCount;

  const _BentoCard({
    required this.color,
    required this.icon,
    required this.title,

    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, size: 32, color: Colors.black54),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '$taskCount Tasks',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
