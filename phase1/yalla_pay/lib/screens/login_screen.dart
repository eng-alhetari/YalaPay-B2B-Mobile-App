import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_pay/providers/login_provider.dart';
import 'package:yalla_pay/providers/user_provider.dart';
import 'package:yalla_pay/routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String email = ''; // State variable for email
  String password = ''; // State variable for password
  String _errorMessage = ''; // To display login error
  bool _isPasswordVisible = false; // Manage password visibility state

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(userNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  email = value; // Update email state
                  _errorMessage = ''; // Clear error message when user types
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  password = value; // Update password state
                  _errorMessage = ''; // Clear error message when user types
                });
              },
              obscureText: !_isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Toggle the visibility state
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (){
                if (email.isEmpty || password.isEmpty) {
                  setState(() {
                    _errorMessage = 'Please enter both email and password';
                  });
                  return;
                }

                if (users.where((u) => u.email == email && u.password == password).isNotEmpty) {
                  ref.read(loginNotifierProvider.notifier).login();
                  context.goNamed(AppRouter.dashboard.name);
                } else {
                  setState(() {
                    _errorMessage = 'Username or password is incorrect';
                  });
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
