import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'users';

  Future<void> addUser(UserModel user) async {
    await _firestore.collection(collectionPath).add(user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

  Future<void> deleteUser(String docId) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<void> updateUser(String docId, UserModel updatedUser) async {
    await _firestore
        .collection(collectionPath)
        .doc(docId)
        .update(updatedUser.toMap());
  }
}

final userRepoProvider = Provider<UserRepository>((ref) => UserRepository());

final userListProvider = FutureProvider<List<UserModel>>((ref) async {
  final repo = ref.watch(userRepoProvider);
  return repo.getUsers();
});

final addUserProvider = FutureProvider.family<void, UserModel>((
  ref,
  user,
) async {
  final repo = ref.watch(userRepoProvider);
  await repo.addUser(user);
});
