import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart'; // Hive support for Flutter
import 'package:path_provider/path_provider.dart'; // To get app document directory (needed on mobile)
import 'package:todoapp/home_screen.dart'; // Main screen of the app
import 'package:todoapp/models/todo_model.dart'; // Hive model & adapter

void main() async {
  // Ensures Flutter bindings are initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory (platform-specific path)
  var directory = await getApplicationDocumentsDirectory();

  // Initialize Hive with the directory path
  Hive.init(directory.path);

  // Register the adapter generated for TodoModel (todo_model.g.dart)
  Hive.registerAdapter(TodoModelAdapter());

  // Open a Hive box named 'todos' to store TodoModel objects
  // This box will be used throughout the app via Boxes.getData()
  await Hive.openBox<TodoModel>('todos');

  // Run the main application widget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        // Use Material 3 color scheme with a seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(), // First screen to display when app starts
    );
  }
}
