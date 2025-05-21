import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../widgets/custom_input_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    final passwordController = TextEditingController();

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
              CustomInputField(controller: nameController, label: 'Name'),
              const SizedBox(height: 12),
              CustomInputField(controller: emailController, label: 'Email'),
              const SizedBox(height: 12),
              CustomInputField(controller: phoneController, label: 'Phone Number'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(controller: otpController, label: 'OTP'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Send OTP'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomInputField(controller: passwordController, label: 'Password', obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
