import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:snotes/Model/classes/note.dart';
import 'package:snotes/Model/sql/database_service.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Note> notes = [];

  Future<void> initialize() async {
    try {
      await _databaseService.initialize();
      updateNotes();
    } catch (e) {
      log('Error initializing NoteProvider: $e');
    }
  }

  Future<int> insertNote(Note note) async {
    try {
      int id = await _databaseService.insertNote(note);
      updateNotes();
      return id;
    } catch (e) {
      log('Error inserting note: $e');
      return 0;
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _databaseService.deleteNote(note);
      updateNotes();
    } catch (e) {
      log('Error deleting note: $e');
    }
  }

  Future<void> updateNote(
    Note note,
  ) async {
    try {
      if (note.title.isNotEmpty) {
        await _databaseService.updateNote(note);
        updateNotes();
      } else {
        await deleteNote(note);
      }
    } catch (e) {
      log('Error updating note: $e');
    }
  }

  Future<void> colorUpdate(Note note) async {
    try {
      await _databaseService.updateNote(note);
      updateNotes();
    } catch (e) {
      colorUpdate(note);
    }
  }

  Future<void> deleteDB() async {
    try {
      await _databaseService.deleteDB();
    } catch (e) {
      log('Error deleting database: $e');
    }
  }

  Note getNoteById(int id) {
    Note note = notes.firstWhere((element) => element.id == id,
        orElse: () => notes.last);
    return note;
  }

  void insertTempNote(Note note) {
    notes.add(note);
  }

  Future<void> updateNotes() async {
    List<Note> backup = [...notes];
    try {
      List<Note> temp = await _databaseService.getAllNotes();
      notes = [...temp];
      notes.map((e) => log(e.id.toString()));
    } catch (e) {
      notes = [...backup];
      log('Error updating notes list: $e');
    }
    notifyListeners();
  }
}
