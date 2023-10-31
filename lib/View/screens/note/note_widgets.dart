// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/Controller/theme_provider.dart';
import 'package:snotes/Model/classes/note.dart';

Future<void> taskThemeBottomSheet(BuildContext context, Note note) {
  NoteProvider provider = Provider.of<NoteProvider>(context, listen: false);

  return showModalBottomSheet<void>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.1),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .2),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: context
                .watch<NoteProvider>()
                .notes
                .firstWhere((element) => element.id == note.id)
                .lightColor),
        child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: MyColors.colors.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  note.color = MyColors.colors[index];
                  provider.colorUpdate(note);
                },
                child: Container(
                  width: 80,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColors.colors[index]),
                  child: const Center(
                    child: Icon(Icons.text_fields_rounded),
                  ),
                ),
              );
            }),
      );
    },
  );
}

class NoteDate extends StatelessWidget {
  const NoteDate({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      children: [
        Text(
          DateFormat('d MMM').format(note.date),
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'work',
          ),
        ),
        Text(
          DateFormat('h:mm a').format(
            DateTime(2023, 1, 2, note.date.hour, note.date.minute),
          ),
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'work',
          ),
        ),
      ],
    );
  }
}

class NoteDescription extends StatelessWidget {
  const NoteDescription({
    super.key,
    required this.descriptionController,
  });

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: descriptionController,
      enableSuggestions: true,
      cursorColor: Colors.black,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: "Description",
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'work',
        ),
        border: InputBorder.none,
      ),
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'work',
        color: Colors.black,
      ),
    );
  }
}

class NoteTitle extends StatelessWidget {
  const NoteTitle({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleController,
      cursorColor: Colors.black,
      enableSuggestions: true,
      textInputAction: TextInputAction.done,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 24,
          fontFamily: 'work',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        border: InputBorder.none,
      ),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFamily: 'work',
        color: Colors.black,
      ),
    );
  }
}
