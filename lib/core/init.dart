import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


import '../features/data/datasource/local_task_datasource.dart';
import '../features/data/repo/task_repo_impl.dart';
import '../features/domain/models/task_model.dart';
import '../features/domain/repo/i_task_repo.dart';

// --- 1. Database Initialization ---

/// Provides the single instance of the Drift database.
/// We use [ref.onDispose] to ensure the database connection closes 
/// when the app is shut down or the provider is reset.
/// 
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});



// --- 2. Data Source Initialization ---

/// Provides the concrete Local Data Source.
/// It depends on the [databaseProvider].
/// 
final localTaskDataSourceProvider = Provider<LocalTaskDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalTaskDataSource(db);
});




// --- 3. Repository Initialization (DI) ---

/// Provides the Task Repository.
/// Note: We type it as the Interface [ITaskRepository] but 
/// return the Implementation [TaskRepositoryImpl]. 
/// This is the "Clean Architecture" way to handle DI.
/// 
final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  final localDataSource = ref.read(localTaskDataSourceProvider);
  return TaskRepositoryImpl(localDataSource);
});



// --- 4. Global Configuration (Other Inits) ---

/// A simple provider for tracking global app state (e.g., Theme, Auth status).
/// You can add more "init" providers here as your app grows.
final appInitializedProvider = StateProvider<bool>((ref) => false);