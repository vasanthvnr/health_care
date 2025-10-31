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
    String phone,
    String password,
    String otp,
    String healthIssues, // <-- Added
  ) async {
    final verifyUrl = Uri.parse(
        'http://10.0.2.2:8080/api/auth/verify-otp'); // Replace with your IP

    try {
      // Step 1: Verify OTP
      final otpResponse = await http.post(
        verifyUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phone,
          'otp': otp,
        }),
      );

      if (otpResponse.statusCode != 200) {
        _showErrorDialog(context, 'OTP verification failed');
        return;
      }

      // Step 2: Proceed with registration
      final registerUrl = Uri.parse(
          'http://10.0.2.2:8080/api/auth/signup'); // Replace with your IP

      final response = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'password': password,
          'healthIssues': healthIssues, // <-- Added to request
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
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    final passwordController = TextEditingController();
    final healthIssuesController = TextEditingController(); // <-- Added

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
              CustomInputField(controller: nameController, label: 'Name', hintText: 'Enter Name',),
              const SizedBox(height: 12),
              CustomInputField(controller: emailController, label: 'Email', hintText: 'Enter Email',),
              const SizedBox(height: 12),
              CustomInputField(
                  controller: phoneController, label: 'Phone Number', hintText: 'Enter Mobile Number',),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                        controller: otpController, label: 'OTP', hintText: 'Enter OTP',),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final phone = phoneController.text.trim();

                      if (phone.isEmpty) {
                        _showErrorDialog(context, 'Phone number is required');
                        return;
                      }

                      final otpUrl =
                          Uri.parse('http://10.0.2.2:8080/api/auth/send-otp');

                      try {
                        final response = await http.post(
                          otpUrl,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'phoneNumber': phone}),
                        );

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP Sent')),
                          );
                        } else {
                          _showErrorDialog(context, 'Failed to send OTP');
                        }
                      } catch (e) {
                        _showErrorDialog(context, 'Error sending OTP: $e');
                      }
                    },
                    child: const Text('Send OTP'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: passwordController,
                label: 'Password',
                obscureText: true, hintText: 'enter password',
              ),
              const SizedBox(height: 12),
              CustomInputField(
                controller: healthIssuesController,
                label: 'Any Health Issues?', hintText: 'e.g., Asthma, Allergy, Diabetes',
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
                      phoneController.text.trim().isEmpty ||
                      otpController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty ||
                      healthIssuesController.text.trim().isEmpty) {
                    _showErrorDialog(context,
                        'All fields are required, including Health Issues');
                    return;
                  }

                  _registerUser(
                    context,
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                    passwordController.text,
                    otpController.text,
                    healthIssuesController.text, // <-- Mandatory check
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
