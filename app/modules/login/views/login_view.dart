import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "B612Mono-Bold",
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Mobile",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "B612Mono-Bold",
                            fontSize: 28,
                          ),
                        ),                       
                        Text(
                          "PRESENCE",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "B612Mono-Bold",
                            fontSize: 28,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please login with email password",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "B612Mono-Bold",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              TextField(
                autocorrect: false,
                controller: controller.emailC,
                decoration: const InputDecoration(
                  labelText: "email",
                  prefixIcon: Icon(Icons.email),
                  contentPadding: EdgeInsets.all(14),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                autocorrect: false,
                controller: controller.passC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "password",
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.all(14),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: const Text("Forgot Password?")),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await controller.login();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    controller.isLoading.isFalse ? "Login" : "Loading...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "B612Mono-Bold",
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
