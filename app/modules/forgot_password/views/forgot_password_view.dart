import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "B612Mono-Bold",
              letterSpacing: 1,
            ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "email",
              prefixIcon: Icon(Icons.email),
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          Obx(() => ElevatedButton(onPressed: () {
            if (controller.isLoading.isFalse) {
              controller.sendEmail();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue
          ),
          child: Text(
            controller.isLoading.isFalse 
            ? "Send Email Reset Password" 
            : "Loading...",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "B612Mono-Bold",
              letterSpacing: 1,
            ),
            ),
          ),
          ),
        ]
      ),
    );
  }
}
