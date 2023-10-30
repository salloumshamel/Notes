// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snotes/Controller/note_provider.dart';
import 'package:snotes/Model/classes/note.dart';

Widget taskWidget(BuildContext context, Note task) {
  return GestureDetector(
    onLongPress: () {
      taskOptionsBottomSheet(context, task);
    },
    onTap: () {
      Navigator.pushNamed(context, '/note', arguments: task.id);
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: task.color, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: task.isComplete
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            task.description.toString(),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'work',
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy-MM-dd').format(task.date),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: 'work',
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(
                  DateTime(2023, 12, 1, task.date.hour, task.date.minute),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  fontFamily: 'work',
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Future<void> taskOptionsBottomSheet(BuildContext context, Note task) {
  NoteProvider provider = Provider.of<NoteProvider>(context, listen: false);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height *
              0.75, // Set a percentage of the screen height
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.delete),
              title: const Text(
                'Delete This Task',
                style: TextStyle(
                  fontFamily: 'work',
                ),
              ),
              onTap: () {
                provider.deleteNote(task);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: task.isComplete
                  ? const Icon(CupertinoIcons.refresh_thick)
                  : const Icon(CupertinoIcons.check_mark),
              title: task.isComplete
                  ? const Text(
                      'Not Completed',
                      style: TextStyle(
                        fontFamily: 'work',
                      ),
                    )
                  : const Text(
                      'Complete',
                      style: TextStyle(
                        fontFamily: 'work',
                      ),
                    ),
              onTap: () {
                task.isComplete = !task.isComplete;
                provider.updateNote(task).then(
                  (_) {
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
