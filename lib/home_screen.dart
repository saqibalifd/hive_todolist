import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todoapp/add_note_screen.dart';
import 'package:todoapp/boxes/boxes.dart';
import 'package:todoapp/models/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color getRandomDimColor() {
    final Random random = Random();
    return Color.fromRGBO(
      180 + random.nextInt(51),
      180 + random.nextInt(51),
      180 + random.nextInt(51),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List", style: GoogleFonts.dmSerifDisplay()),
        centerTitle: true,
      ),

      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<TodoModel>();

          if (data.isEmpty) {
            return Center(child: Text('Todo List is empty'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey('id'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                onDismissed: (_) async {
                  data[index].delete();
                },

                child: Card(
                  color: getRandomDimColor(),
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen(todoModel: data[index]),
                        ),
                      );
                    },

                    title: Text(
                      data[index].title,
                      style: GoogleFonts.dmSerifDisplay(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

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

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
