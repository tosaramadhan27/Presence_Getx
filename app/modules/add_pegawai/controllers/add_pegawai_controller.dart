import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty && jobC.text.isNotEmpty && nipC.text.isNotEmpty && emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
          UserCredential userCredential = await auth.createUserWithEmailAndPassword(
            email: emailC.text,
            password: "password"
          );
          
          if (userCredential.user != null) {
            String uid = userCredential.user!.uid;

            await firestore.collection("pegawai").doc(uid).set({
              "nip" : nipC.text,
              "name" : nameC.text,
              "job" : jobC.text,
              "email" : emailC.text,
              "uid" : uid,
              "role" : "pegawai",
              "createdAt" : DateTime.now().toIso8601String(),
            });
            Get.back();
            Get.snackbar("Berhasil", "Pegawai baru ditambahkan.");
          
            await userCredential.user!.sendEmailVerification();
          }
          // print(userCredential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              Get.snackbar("Terjadi Kesalahan", "password yang digunakan terlalu singkat.");
            } else if (e.code == 'email-already-in-use') {
              Get.snackbar("Terjadi Kesalahan", "pegawai sudah ada.");
            }
          } catch (e) {
            Get.snackbar("Terjadi Kesalahan", "tidak dapat menambahkan pegawai.");
          } finally {
            isLoading.value = false;
          }
    } else {
      Get.snackbar("Terjadi Kesalahan", "nip, nama, job, dan email harus diisi.");
    }
  }
}
