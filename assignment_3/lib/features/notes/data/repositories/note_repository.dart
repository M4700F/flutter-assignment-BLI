import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/note_model.dart';

part 'note_repository.g.dart';

class NoteRepository {
  final DatabaseService _databaseService;
  final _store = StoreRef<String, Map<String, dynamic>>(AppConstants.notesStore);

  NoteRepository(this._databaseService);

  Future<List<Note>> getAllNotes() async {
    final db = await _databaseService.database;
    final snapshots = await _store.find(db);
    
    return snapshots
        .map((snapshot) => Note.fromJson(snapshot.value))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<Note?> getNoteById(String id) async {
    final db = await _databaseService.database;
    final snapshot = await _store.record(id).get(db);
    
    if (snapshot == null) return null;
    return Note.fromJson(snapshot);
  }

  Future<void> createNote(Note note) async {
    final db = await _databaseService.database;
    await _store.record(note.id).put(db, note.toJson());
  }

  Future<void> updateNote(Note note) async {
    final db = await _databaseService.database;
    await _store.record(note.id).update(db, note.toJson());
  }

  Future<void> deleteNote(String id) async {
    final db = await _databaseService.database;
    await _store.record(id).delete(db);
  }

  Stream<List<Note>> watchNotes() async* {
    final db = await _databaseService.database;
    
    yield* _store.query().onSnapshots(db).map((snapshots) {
      return snapshots
          .map((snapshot) => Note.fromJson(snapshot.value))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    });
  }
}

@riverpod
NoteRepository noteRepository(Ref ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return NoteRepository(databaseService);
}