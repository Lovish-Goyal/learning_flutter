import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'notes';

  Future<List<NoteModel>> getNotes() async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs
        .map((doc) => NoteModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addNote(NoteModel note) async {
    await _firestore.collection(collectionPath).add(note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    await _firestore
        .collection(collectionPath)
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }
}

class NoteNotifier extends StateNotifier<List<NoteModel>> {
  final NoteRepository repository;

  NoteNotifier(this.repository) : super([]) {
    loadNotes(); // Initial load
  }

  Future<void> loadNotes() async {
    final notes = await repository.getNotes();
    state = notes;
  }

  Future<void> addNote(NoteModel note) async {
    await repository.addNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel updatedNote) async {
    await repository.updateNote(updatedNote);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadNotes();
  }
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

final noteNotifierProvider =
    StateNotifierProvider<NoteNotifier, List<NoteModel>>((ref) {
      final repository = ref.watch(noteRepositoryProvider);
      return NoteNotifier(repository);
    });
