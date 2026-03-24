import 'package:flutter/material.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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

        // 4. Ongoing Tasks List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const _OngoingTaskCard(),
            childCount: 10, // Matches the screenshot
          ),
        ),
      ],
    );
  }
}

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

class _OngoingTaskCard extends StatelessWidget {
  const _OngoingTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'High',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Text(
                '82%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Salon App Wireframe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Row(
          //   children: const [
          //     Icon(Icons.access_time, color: Colors.grey, size: 16),
          //     SizedBox(width: 8),
          //     Text('10:00 AM - 06:00 PM', style: TextStyle(color: Colors.grey)),
          //   ],
          // ),
          Text(
            "data jsadf kasjd fkajsdn fkajsnd fkjasn dfkjasn dkjnask djfnkasjn dfkljsan dfkjand jas fjsd. kjsd fkasjdfkajsd jfkash dfjk hasjdhfbjash fdj",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Due Date: August 25',
                style: TextStyle(color: Colors.grey),
              ),
              // Simple Avatars Placeholder
              SizedBox(
                width: 50,
                height: 30,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blueGrey.shade800,
                    ),
                    Positioned(
                      left: 15,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.brown.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
