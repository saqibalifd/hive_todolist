import 'package:hive/hive.dart';
import 'package:todoapp/models/todo_model.dart';

class Boxes {
  /// This static method returns the Hive box that stores TodoModel objects.
  ///
  /// - 'todos' is the box name. It must match the name you used when opening the box in main.dart:
  ///   `await Hive.openBox<TodoModel>('todos');`
  ///
  /// - The return type is `Box<TodoModel>`, meaning the box only stores TodoModel objects.
  ///
  /// Usage example:
  ///   final box = Boxes.getData();
  ///   box.add(TodoModel(title: "task", description: "details"));
  static Box<TodoModel> getData() => Hive.box<TodoModel>('todos');
}
