import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/Controller/theme_provider.dart';
import 'package:snotes/Model/classes/note.dart';
import 'package:snotes/View/screens/home/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        forceMaterialTransparency: true,
        backgroundColor: MyColors.darkColor,
        title: const Text(
          'Notes',
          style:
              TextStyle(color: Colors.white, fontFamily: 'work', fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shape: const CircleBorder(
          eccentricity: 0.2,
          side: BorderSide(width: 1, color: Colors.white),
        ),
        onPressed: () async {
          _handleAddNote(context);
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: _buildNoteList(context),
    );
  }

  void _handleAddNote(BuildContext context) async {
    final provider = Provider.of<NoteProvider>(context, listen: false);

    Note emptyNote = Note(
      title: '',
      description: '',
      date: DateTime.now(),
      color: MyColors.getRandomColor(),
      isComplete: false,
      id: 0,
    );

    final value = await provider.insertNote(emptyNote);
    log(value.toString());

    if (value != 0) {
      Navigator.pushNamed(context, '/note', arguments: value);
    }
  }

  Widget _buildNoteList(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, value, child) {
        if (value.notes.isNotEmpty) {
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: value.notes.length,
            itemBuilder: (context, index) {
              log('$index ');
              return taskWidget(context, value.notes[index]);
            },
          );
        } else {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Empty :(',
                style: TextStyle(
                    fontFamily: 'work', color: Colors.white, fontSize: 25),
              ),
              Text(
                'add a new note',
                style: TextStyle(
                    fontFamily: 'work', color: Colors.white, fontSize: 18),
              ),
            ],
          ));
        }
      },
    );
  }
}
