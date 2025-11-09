import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_routes.dart';
import '../widgets/custom_input_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  Future<void> _registerUser(
    BuildContext context,
    String name,
    String email,
    String password,
    String healthIssues,
  ) async {
    try {
      final registerUrl = Uri.parse(
        'https://mista-java-backend.onrender.com/api/auth/signup', // Update with your deploy URL if needed
      );

      final response = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'healthIssues': healthIssues,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Registration failed';
        _showErrorDialog(context, error);
      }
    } catch (e) {
      _showErrorDialog(context, 'Error: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final healthIssuesController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              CustomInputField(
                controller: nameController,
                label: 'Name',
                hintText: 'Enter Name',
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: emailController,
                label: 'Email',
                hintText: 'Enter Email',
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: passwordController,
                label: 'Password',
                obscureText: true,
                hintText: 'Enter Password',
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: healthIssuesController,
                label: 'Any Health Issues?',
                hintText: 'e.g., Asthma, Allergy, Diabetes',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty ||
                      healthIssuesController.text.trim().isEmpty) {
                    _showErrorDialog(
                        context, 'All fields are required, including Health Issues');
                    return;
                  }

                  _registerUser(
                    context,
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                    healthIssuesController.text,
                  );
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
