import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todoapp/boxes/boxes.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/widgets/custom_button_widget.dart';

class AddNoteScreen extends StatefulWidget {
  final TodoModel? todoModel;
  const AddNoteScreen({super.key, this.todoModel});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todoModel != null) {
      titleController.text = widget.todoModel!.title;
      descriptionController.text = widget.todoModel!.description;
    }
  }

  // --- Step 3: Save or update note in the database.
  Future<void> _saveNote() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title & description required")),
      );
      return;
    }

    if (widget.todoModel == null) {
      try {
        final data = TodoModel(
          title: titleController.text,
          description: descriptionController.text,
        );
        final box = Boxes.getData();
        box.add(data);
        data.save();
        Navigator.pop(context);
      } catch (e) {
        print('error found in adding todo $e');
      }
    } else {
      try {
        final data = TodoModel(
          title: 'ali',
          description: descriptionController.text,
        );
        data.save();
        Navigator.pop(context);
      } catch (e) {
        print('error found in updating todo : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ehheehehheeheheheh${widget.todoModel}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todoModel == null ? 'Add Note' : 'Edit Note',
          style: GoogleFonts.dmSerifDisplay(),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_circle_left),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
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

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButtonWidget(
          title: widget.todoModel == null ? 'Add Note' : 'Update Note',
          onTap: _saveNote,
        ),
      ),
    );
  }
}
