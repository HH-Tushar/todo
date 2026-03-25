import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_today/features/presentation/screens/home/home_view.dart';

import 'core/init.dart';
import 'features/presentation/screens/landing_view.dart';

// Import your Home Screen here
// import 'features/todo/presentation/pages/todo_home_page.dart';

void main() async {
  // 1. Ensure Flutter framework is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wrap the entire App in ProviderScope for Riverpod
  runApp(const ProviderScope(child: TaskTodayApp()));
}

class TaskTodayApp extends ConsumerWidget {
  const TaskTodayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can watch our initialization provider here if needed
    final isInitialized = ref.watch(appInitializedProvider);

    return MaterialApp(
      title: 'Task Today',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,

          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
          ),
        ),

        textTheme: TextTheme(
          // bodyMedium: TextStyle(color: Colors.white),
          // titleMedium: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        canvasColor: Colors.black,
        colorScheme: const ColorScheme.dark(surface: Colors.black),
      ),

      // Set the initial route or home widget
      home: const HomeView(),
    );
  }
}

/// A temporary placeholder to verify the app runs.
/// You will replace this with your actual TodoHomePage.
class TodoPlaceholderPage extends ConsumerWidget {
  const TodoPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Today'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Database & DI Initialized!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Drift + Riverpod 3.x is ready.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Testing if the DI works
                final repo = ref.read(taskRepositoryProvider);
                debugPrint("Repository Type: ${repo.runtimeType}");
              },
              child: const Text('Test Repository DI'),
            ),
          ],
        ),
      ),
    );
  }
}
