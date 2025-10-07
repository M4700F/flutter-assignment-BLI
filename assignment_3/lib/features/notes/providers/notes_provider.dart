import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';

part 'notes_provider.g.dart';

@riverpod
class Notes extends _$Notes {
  @override
  Stream<List<Note>> build() {
    final repository = ref.watch(noteRepositoryProvider);
    return repository.watchNotes();
  }

  Future<void> createNote({
    required String title,
    required String content,
  }) async {
    final repository = ref.read(noteRepositoryProvider);
    final now = DateTime.now();
    
    final note = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    await repository.createNote(note);
  }

  Future<void> updateNote(Note note) async {
    final repository = ref.read(noteRepositoryProvider);
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await repository.updateNote(updatedNote);
  }

  Future<void> deleteNote(String id) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.deleteNote(id);
  }
}

@riverpod
Future<Note?> noteById(Ref ref, String id) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNoteById(id);
}