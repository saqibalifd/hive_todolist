import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For using custom fonts
import 'package:iconsax/iconsax.dart'; // For icons
import 'package:todoapp/boxes/boxes.dart'; // Hive boxes helper
import 'package:todoapp/models/todo_model.dart'; // Hive model
import 'package:todoapp/widgets/custom_button_widget.dart'; // Custom button

class AddNoteScreen extends StatefulWidget {
  // Accepts an optional TodoModel for editing.
  // If null → adding a new note. If not null → editing existing note.
  final TodoModel? todoModel;
  const AddNoteScreen({super.key, this.todoModel});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // Controllers for text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If editing, pre-fill text fields with existing values
    if (widget.todoModel != null) {
      titleController.text = widget.todoModel!.title;
      descriptionController.text = widget.todoModel!.description;
    }
  }

  /// Save or update note in the Hive database.
  Future<void> _saveNote() async {
    // Validation: both fields must be filled
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title & description required")),
      );
      return;
    }

    // Case 1: Adding a new note
    if (widget.todoModel == null) {
      try {
        final data = TodoModel(
          title: titleController.text,
          description: descriptionController.text,
        );
        final box = Boxes.getData(); // Get Hive box
        box.add(data); // Add new note
        data.save(); // Save object
        Navigator.pop(context); // Go back after saving
      } catch (e) {
        print('error found in adding todo $e');
      }
    }
    // Case 2: Updating an existing note
    else {
      try {
        final updatedData = TodoModel(
          title: titleController.text,
          description: descriptionController.text,
        );
        // Replace old note with new data in the box
        await widget.todoModel!.box!.put(widget.todoModel!.key, updatedData);

        Navigator.pop(context); // Go back after updating
      } catch (e) {
        print('error found in updating todo : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug print (not needed in production)
    print('Current todo: ${widget.todoModel}');
    return Scaffold(
      appBar: AppBar(
        // Title changes depending on whether adding or editing
        title: Text(
          widget.todoModel == null ? 'Add Note' : 'Edit Note',
          style: GoogleFonts.dmSerifDisplay(),
        ),
        // Back button
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_circle_left),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),

      // Body with text fields
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: GoogleFonts.dmSerifDisplay(color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: GoogleFonts.dmSerifDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(color: Colors.cyanAccent),

            // Description input field (multiline)
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allow unlimited lines
              minLines: 3, // Start with at least 3 lines
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: GoogleFonts.dmSerifDisplay(color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: GoogleFonts.dmSerifDisplay(fontSize: 16),
            ),
          ],
        ),
      ),

      // Bottom button for adding/updating notes
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButtonWidget(
          title: widget.todoModel == null ? 'Add Note' : 'Update Note',
          onTap: _saveNote, // Call save method
        ),
      ),
    );
  }
}
