import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../domain/models/task_status.dart';

part 'task_model.g.dart';

// This class defines the table structure. 
// Drift will generate a 'Task' class based on this.
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();
  
  // High-performance Indexing for your search/sort requirements
  IntColumn get status => intEnum<TaskStatus>()(); 
  IntColumn get taskType => intEnum<TaskType>()(); 
  IntColumn get taskPriority => intEnum<TaskPriority>()(); 
  DateTimeColumn get deadline => dateTime()();
  
  BoolColumn get hasReminder => boolean().withDefault(const Constant(false))();
  // TextColumn get taskType => text().withDefault(const Constant('Personal'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  // Syncing metadata for your future Firebase integration
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime().withDefault(currentDateAndTime)();

}

@TableIndex(name: 'tasks_status_idx', columns: {#status})
@TableIndex(name: 'tasks_priority_idx', columns: {#taskPriority})
@TableIndex(name: 'tasks_deadline_idx', columns: {#deadline})

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}