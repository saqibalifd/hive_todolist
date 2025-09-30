import 'dart:math'; // For generating random colors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:hive_flutter/adapters.dart'; // To use Hive with Flutter
import 'package:iconsax/iconsax.dart'; // For extra icons
import 'package:todoapp/add_note_screen.dart'; // Screen for adding or editing notes
import 'package:todoapp/boxes/boxes.dart'; // Helper class to access Hive boxes
import 'package:todoapp/models/todo_model.dart'; // Hive model class

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Generates a random pastel-like color for list items.
  Color getRandomDimColor() {
    final Random random = Random();
    return Color.fromRGBO(
      180 + random.nextInt(51), // Random R value (180–230)
      180 + random.nextInt(51), // Random G value (180–230)
      180 + random.nextInt(51), // Random B value (180–230)
      1, // Full opacity
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar
      appBar: AppBar(
        title: Text("Todo List", style: GoogleFonts.dmSerifDisplay()),
        centerTitle: true,
      ),

      // Body listens to changes in Hive box using ValueListenableBuilder
      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(), // React to box changes
        builder: (context, box, child) {
          // Convert box values into a List<TodoModel>
          var data = box.values.toList().cast<TodoModel>();

          // Show message when no todos exist
          if (data.isEmpty) {
            return const Center(child: Text('Todo List is empty'));
          }

          // Build list of todos
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey('id'), // Unique key for each item
                direction: DismissDirection.endToStart, // Swipe right to left
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                // Delete the item when dismissed
                onDismissed: (_) async {
                  data[index].delete();
                },

                // Each todo displayed in a Card
                child: Card(
                  color: getRandomDimColor(), // Random light color
                  child: ListTile(
                    // Tap to edit the todo
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen(todoModel: data[index]),
                        ),
                      );
                    },

                    // Title text of todo
                    title: Text(
                      data[index].title,
                      style: GoogleFonts.dmSerifDisplay(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Subtitle (description) of todo
                    subtitle: Text(
                      data[index].description,
                      style: GoogleFonts.dmSerifDisplay(fontSize: 13),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      // Floating button to add new todos
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddNoteScreen without passing a model (new todo)
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
        },
        backgroundColor: Colors.cyan,
        shape: const CircleBorder(),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }
}
