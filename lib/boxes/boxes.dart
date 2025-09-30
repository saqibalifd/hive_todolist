import 'package:hive/hive.dart';
import 'package:todoapp/models/todo_model.dart';

class Boxes {
  static Box<TodoModel> getData() => Hive.box<TodoModel>('todos');
}
