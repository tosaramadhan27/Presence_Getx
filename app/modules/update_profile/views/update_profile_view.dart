import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({super.key});

  final Map<String, dynamic>? user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // print(user);
    controller.nipC.text = user!["nip"];
    controller.nameC.text = user!["name"];
    controller.emailC.text = user!["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
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
            readOnly: true,
            autocorrect: false,
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: "NIP",
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Name",
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "Photo Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(builder: (c) {
                if (c.image != null) {
                  return ClipOval(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        File(c.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  if (user!["profile"] != null) {
                    return Column(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              user!["profile"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // konfirmasi alert delete profile
                            Get.defaultDialog(
                              title: "Confirm!",
                              middleText: "Delete profile picture?",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text("No", style: TextStyle(color: Colors.white)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.deleteProfile(user!["uid"]);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Yes", style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            );                           
                          },
                          child: const Text("delete"))
                      ],
                    );
                  } else {
                    return const Text("no image");
                  }
                }
              }),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: const Text("choose"))
            ],
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                await controller.updateprofile(user!["uid"]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                controller.isLoading.isFalse 
                ? "Update" 
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
      ),
    );
  }
}
