import 'package:flutter/material.dart';
import 'package:matchbox_app/config.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? errorText;

  Future<void> _register(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      await context.read<AuthProviders>().register(
            nameController.text.trim(),
            emailController.text.trim(),
            passwordController.text.trim()
          );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorText = "Registration failed. Try a different email.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Create an Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              cursorColor: appColors.red,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 12),
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
              onPressed: isLoading ? null : () => _register(context),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  :  Text("Register",style: TextStyle(color: appColors.white)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("Already have an account? Login",style: TextStyle(color: appColors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
