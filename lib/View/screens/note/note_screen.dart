import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/Model/classes/note.dart';
import 'package:snotes/View/screens/note/note_widgets.dart';

class NoteScreen extends StatelessWidget {
  final int id;
  NoteScreen({Key? key, required this.id}) : super(key: key);
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController descriptionController =
      TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {

        Note? note = provider.getNoteById(id);
        
        if (note == null) {
          return const SizedBox();
        }
        
        titleController.text = note.title;
        descriptionController.text = note.description;
        
        return WillPopScope(
          onWillPop: () async {
            _updateTD(note, provider, false);
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
                onPressed: () async {
                  Navigator.pop(context);
                  await _updateTD(note, provider, false);
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

  Future<void> _updateTD(
      Note note, NoteProvider provider, bool isColorUpdate) async {
    note.title = titleController.text;
    note.description = descriptionController.text;
    await provider.updateNote(note);
  }
}
