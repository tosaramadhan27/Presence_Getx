import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail () async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil", "kami telah mengirimkan email reset password ke email anda");
        Get.offAllNamed(Routes.LOGIN);
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "tidak dapat mengirim email reset password");
      } finally {
        isLoading.value = false;
      }    
    }
  }

}
