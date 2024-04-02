import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword () async {
    if (currC.text.isNotEmpty && newC.text.isNotEmpty && confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(email: emailUser, password: currC.text);
          await auth.currentUser!.updatePassword(newC.text);
          // getback dulu baru tampilkan snackbar
          Get.back();
          Get.snackbar("Berhasil", "Berhasil update password");

        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi Kesalahan", "Password yang dimasukkan salah. Tidak dapat update password");
          }  else {
            // Get.snackbar("Terjadi Kesalahan", e.code.toLowerCase());         
            
          }
          Get.snackbar("Terjadi Kesalahan", "Password setidaknya 6 digit");         
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Confirm password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua input harus diisi");
    }
  }


}
