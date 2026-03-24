# Task Today

A modern Flutter-based todo application designed for efficient task management with a sleek dark theme interface.

## Features

- **Task Management**: Create, edit, delete, and track tasks
- **Task Status Tracking**: Organize tasks by status (Todo, In Progress, Stuck, Completed)
- **Search & Filter**: Find tasks quickly with search functionality and status filtering
- **Sorting Options**: Sort tasks by deadline, title, or status
- **Reminders**: Set reminders for important tasks
- **Task Categories**: Organize tasks by type (Personal, Work, etc.)
- **Offline-First**: All data stored locally for instant access

## Tech Stack

### State Management
- **Riverpod**: Used for dependency injection and state management
  - ProviderScope wraps the entire app for global state access
  - StateNotifier for complex state changes (task CRUD operations)
  - StateProvider for simple filter states (search, sort, status filters)
  - StreamProvider for reactive database queries
  - Automatic dependency injection with clean separation of concerns

### Local Database
- **Drift (formerly Moor)**: Reactive persistence library for Flutter
  - SQLite-based local database with type-safe queries
  - Automatic code generation for database schema and queries
  - Real-time reactive streams for UI updates
  - Migration support for schema changes
  - Optimized for performance with indexing on search/sort fields

### Architecture
- **Clean Architecture**: Separation of concerns with distinct layers
  - **Domain Layer**: Business logic, entities (Task model), and repository interfaces
  - **Data Layer**: Repository implementations and data sources (Drift database)
  - **Presentation Layer**: UI components, Riverpod providers, and state management

## Getting Started

### Prerequisites
- Flutter SDK (^3.11.1)
- Dart SDK (^3.11.1)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd task_today
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate database code:
```bash
flutter pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

### Database Schema

The app uses a single `Tasks` table with the following structure:
- `id`: Auto-incrementing primary key
- `title`: Task title (required, 1-100 characters)
- `description`: Task description (optional)
- `status`: Task status enum (Todo, In Progress, Stuck, Completed)
- `deadline`: Due date and time
- `hasReminder`: Boolean flag for reminders
- `taskType`: Category/type of task (default: "Personal")
- `createdAt`: Creation timestamp
- `isSynced`: Flag for future cloud sync (default: false)
- `lastModified`: Last modification timestamp

## Usage

### Adding Tasks
- Navigate to the Add tab
- Enter task title, description, deadline, and category
- Tasks are automatically saved to local database

### Managing Tasks
- View all tasks on the Home screen
- Filter by status using the category grid
- Search tasks using the search bar
- Sort by deadline, title, or status
- Tap tasks to toggle completion status
- Swipe or use menu to delete tasks

### State Management Flow
1. UI components watch Riverpod providers
2. Providers interact with repository layer
3. Repository delegates to data source
4. Data source performs Drift database operations
5. Changes propagate back through streams to update UI

## Development

### Code Generation
After modifying database schema or adding new models:
```bash
flutter pub run build_runner build
```

### Testing
Run tests:
```bash
flutter test
```

### Building for Production
```bash
flutter build apk  # For Android
flutter build ios  # For iOS
flutter build macos  # For macOS
```

## Contributing

1. Follow the Clean Architecture principles
2. Use Riverpod for state management
3. Ensure database operations are performed through the repository layer
4. Write tests for new features
5. Run `flutter analyze` before committing

## License

This project is private and not intended for public distribution.

