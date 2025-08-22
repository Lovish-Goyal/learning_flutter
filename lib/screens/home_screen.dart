import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../providers/user_state_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userAsyncProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Users (AsyncNotifier)')),
      body: userState.when(
        data: (users) {
          if (users.isEmpty) return Center(child: Text('No users found.'));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newUser = UserModel(
            name: 'Jane Doe',
            email: 'jane@example.com',
            password: 'jane',
          );
          await ref.read(userAsyncProvider.notifier).addUser(newUser);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
