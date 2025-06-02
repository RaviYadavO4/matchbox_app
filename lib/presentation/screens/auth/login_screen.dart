import 'package:flutter/material.dart';
import 'package:matchbox_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../providers/auth_providers.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  Future<void> _login(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      await context.read<AuthProviders>().login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        errorText = "Invalid email or password.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              cursorColor: appColors.red,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              cursorColor: appColors.red,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            if (errorText != null) ...[
              const SizedBox(height: 8),
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : () => _login(context),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  :  Text("Login",style: TextStyle(color: appColors.white),),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child:  Text("Don't have an account? Register",style: TextStyle(color: appColors.red),),
            ),
          ],
        ),
      ),
    );
  }
}
