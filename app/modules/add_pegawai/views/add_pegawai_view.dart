import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Pegawai',
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
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: "Nip",
              contentPadding: EdgeInsets.all(14),
              prefixIcon: Icon(Icons.assignment_ind_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(autocorrect: false,
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Name",
              contentPadding: EdgeInsets.all(14),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(autocorrect: false,
            controller: controller.jobC,
            decoration: const InputDecoration(
              labelText: "Job",
              contentPadding: EdgeInsets.all(14),
              prefixIcon: Icon(Icons.work),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              contentPadding: EdgeInsets.all(14),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.addPegawai();
                }             
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue
              ),
              child: Text(
                controller.isLoading.isFalse 
                ? "Add Pegawai" 
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
