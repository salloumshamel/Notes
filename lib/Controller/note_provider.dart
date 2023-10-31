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
      await updateNotes();
    } catch (e) {
      log('Error initializing NoteProvider: $e');
    }
  }

  Future<int> insertNote(Note note) async {
    try {
      int id = await _databaseService.insertNote(note);
      await updateNotes();
      return id;
    } catch (e) {
      log('Error inserting note: $e');
      return 0;
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _databaseService.deleteNote(note);
      await updateNotes();
    } catch (e) {
      log('Error deleting note: $e');
    }
  }

  Future<void> updateNoteColor(Note note) async {
    await _databaseService.updateNote(note, false);
    await updateNotes();
  }

  Future<void> updateNote(Note note) async {
    try {
      await _databaseService.updateNote(note, true);
      await updateNotes();
    } catch (e) {
      log('Error updating note: $e');
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
    return notes.firstWhere((element) => element.id == id);
  }

  Future<void> updateNotes() async {
    List<Note> backup = List.from(notes);
    try {
      List<Note> temp = await _databaseService.getAllNotes();
      notes = [...temp];
    } catch (e) {
      notes = [...backup];
      log('Error updating notes list: $e');
    }
    notifyListeners();
  }
}
