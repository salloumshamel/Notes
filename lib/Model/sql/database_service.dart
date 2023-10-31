import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:snotes/Model/classes/note.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database _database;
  String path = 'todo.db';

  DatabaseService() {
    initialize();
  }

  Future<void> initialize() async {
    try {
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await _createDatabase(db: db);
        },
        onOpen: (database) async {
          log('Database opened successfully');
        },
      );
    } catch (e) {
      log('something went wrong (initializeDatabase) $e');
    }
  }

  Future<List<Note>> getAllNotes() async {
    final List<Note> notes = [];
    try {
      final List<Map<String, dynamic>> maps = await _database.query('Note');
      notes.addAll(
        maps.map(
          (map) => Note(
            id: map['id'],
            title: map['title'],
            description: map['description'],
            date: DateTime.parse(map['date']),
            color: Color(map['color']),
            isComplete: map['isComplete'] == 1,
          ),
        ),
      );
      log('Retrieved ${notes.length} tasks successfully');
    } catch (e) {
      log('Error retrieving tasks: $e');
    }
    return notes;
  }

  Future<int> insertNote(Note note) async {
    try {
      int id = await _database.insert('Note', {
        'title': note.title,
        'description': note.description,
        'date': note.date.toString(),
        'color': note.color.value.toInt(),
        'isComplete': note.isComplete ? 1 : 0,
      });
      log('successfully');
      return id;
    } catch (e) {
      log('something went wrong (insert note) $e');
      return 0;
    }
  }

  Future<bool> updateNote(Note note, bool isColor) async {
    try {
      // to handle empty notes
      if (note.title.isEmpty && note.description.isEmpty && !isColor) {
        await deleteNote(note);
        return false;
      }

      await _database.update(
          'Note',
          {
            "title": note.title,
            "description": note.description,
            "date": note.date.toString(),
            "color": note.color.value,
            "isComplete": note.isComplete ? 1 : 0,
          },
          where: "id = ?",
          whereArgs: [note.id]);
      return true;
    } catch (e) {
      log('something went wrong (update task) $e');
      return false;
    }
  }

  Future<bool> deleteNote(Note note) async {
    try {
      await _database.delete('Note', where: 'id =?', whereArgs: [note.id]);
      return true;
    } catch (e) {
      log('something went wrong (delete task) $e');
      return false;
    }
  }

  Future<void> deleteDB() async {
    try {
      await deleteDatabase(path);
    } catch (e) {
      log('something went wrong $e');
    }
  }

  Future<void> _createDatabase({required Database db}) async {
    try {
      await db.execute('''
      CREATE TABLE Note (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,                     
        color INTEGER,
        isComplete INTEGER     
      )
    ''');
      log('Data base created successfully');
    } catch (error) {
      log('something went wrong when we try to create the database! $error');
    }
  }
}
