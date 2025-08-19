import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter/models/user_model.dart';
import 'package:learning_flutter/providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userListProvider);
    return userAsync.when(
      data: (data) => Scaffold(
        appBar: AppBar(title: Text('User List'), backgroundColor: Colors.amber),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = data[index];
                      return ListTile(title: Text(user.name));
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(hint: Text('Enter Your Name')),
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Value can not be null';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(hint: Text('Enter Your Email')),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Value can not be null';
                      } else if (isEmailValid(value) == false) {
                        return 'Email is Not Valid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hint: Text('Enter Your Password'),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Value can not be null';
                      } else if (isPasswordValid(value) == false) {
                        return 'Password is Not Valid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final user = UserModel(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      ref.read(userRepoProvider).addUser(user);
                      ref.invalidate(userListProvider);
                    }
                  },
                  child: Text('Add Data'),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final passwordRegex = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
);

bool isEmailValid(String email) => emailRegex.hasMatch(email);
bool isPasswordValid(String pass) => passwordRegex.hasMatch(pass);
