import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/Model/classes/note.dart';
import 'package:snotes/View/screens/note/note_widgets.dart';

class NoteScreen extends StatelessWidget {
  final int id;
  NoteScreen({Key? key, required this.id}) : super(key: key);
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController descriptionController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        Note note = provider.getNoteById(id);
        titleController.text = note.title;
        descriptionController.text = note.description;
        return WillPopScope(
          onWillPop: () async {
            _updateTD(note, provider);
            return true;
          },
          child: Scaffold(
            backgroundColor: note.color,
            appBar: AppBar(
              backgroundColor: note.color,
              elevation: 0.0,
              forceMaterialTransparency: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  _updateTD(note, provider);
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    taskThemeBottomSheet(context, note);
                  },
                  icon: const Icon(
                    Icons.color_lens_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title Text Field
                    NoteTitle(titleController: titleController),
                    const SizedBox(height: 4),
                    NoteDate(note: note),
                    const SizedBox(height: 4),
                    //Description Text Field
                    NoteDescription(
                        descriptionController: descriptionController),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateTD(Note note, NoteProvider provider) {
    note.title = titleController.text;
    note.description = descriptionController.text;
    provider.updateNote(note);
  }
}
