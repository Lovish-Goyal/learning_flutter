import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'users';

  Future<void> add(UserModel user) async {
    await _firestore.collection(collectionPath).add(user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }
}

class UserAsyncNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepository _userRepository;

  UserAsyncNotifier(this._userRepository) : super(const AsyncValue.loading()) {}

  // @override
  // FutureOr<List<UserModel>> build() async {
  //   final users = await ref.read(userRepositoryProvider).getUsers();
  //   return users;
  // }

  Future<void> addUser(UserModel user) async {
    final currentUsers = state.value ?? [];

    state = const AsyncValue.loading();

    try {
      await _userRepository.add(user);
      state = AsyncValue.data([...currentUsers, user]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userAsyncProvider =
    StateNotifierProvider<UserAsyncNotifier, AsyncValue<List<UserModel>>>(
      (ref) => UserAsyncNotifier(ref.read(userRepositoryProvider)),
    );
