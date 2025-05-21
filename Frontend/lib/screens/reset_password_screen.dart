import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../widgets/custom_input_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool otpSent = false;
  bool otpVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              'Reset your password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!otpSent) ...[
              CustomInputField(controller: phoneController, label: 'Mobile Number'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    otpSent = true;
                  });
                },
                child: const Text('Send OTP'),
              ),
            ] else if (!otpVerified) ...[
              CustomInputField(controller: otpController, label: 'Enter OTP'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    otpVerified = true;
                  });
                },
                child: const Text('Verify OTP'),
              ),
            ] else ...[
              CustomInputField(controller: newPasswordController, label: 'New Password', obscureText: true),
              const SizedBox(height: 16),
              CustomInputField(controller: confirmPasswordController, label: 'Confirm Password', obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  if (newPasswordController.text == confirmPasswordController.text) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
