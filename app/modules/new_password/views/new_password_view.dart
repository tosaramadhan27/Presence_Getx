import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Password',
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
          TextField(
            controller: controller.newPassC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "New Password",
              contentPadding: EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.newPassword();
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
            ),
            child: const Text(
              "Continue",
              style: TextStyle(
              color: Colors.white,
              fontFamily: "B612Mono-Bold",
              letterSpacing: 1,
            ),
            )
          )
        ],
      )
    );
  }
}
