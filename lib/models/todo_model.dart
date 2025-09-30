import 'package:hive/hive.dart';

// This links the generated adapter file with this model.
// After running build_runner, 'todo_model.g.dart' will be created automatically.
part 'todo_model.g.dart';

/// Mark this class as a Hive type so it can be stored in the Hive database.
/// Each model class needs a unique typeId (integer).
/// Keep this number constant once your app is published.
@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  /// Each field you want to store in Hive must have a unique index.
  /// Index numbers must not be changed once in use (to prevent data corruption).
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  /// Constructor for creating a new TodoModel object.
  /// Both title and description are required.
  TodoModel({required this.title, required this.description});
}
