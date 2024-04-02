import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Password',
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
            controller: controller.currC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Current Password",
              prefixIcon: Icon(Icons.password),
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
           TextField(
            controller: controller.newC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "New Password",
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.all(14),
              border:  OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
           TextField(
            controller: controller.confirmC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Confirm New Password",
              prefixIcon: Icon(Icons.lock),
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20,),
          Obx(
            () => ElevatedButton(onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.updatePassword();
              }
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
            ),
            child: Text(
              controller.isLoading.isFalse 
              ? "Update Password" 
              : "Loading...",
              style: const TextStyle(
              color: Colors.white,
              fontFamily: "B612Mono-Bold",
              letterSpacing: 1,
            ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
