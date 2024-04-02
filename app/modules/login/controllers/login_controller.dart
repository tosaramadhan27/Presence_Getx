import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login () async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text,
            password: passC.text,
          );
          // print(userCredential);

          if (userCredential.user != null) {
            if (userCredential.user!.emailVerified == true) {
              if (passC.text == "password") {
                Get.offAllNamed(Routes.NEW_PASSWORD);
              } else {
                Get.snackbar("Berhasil Login", "Welcome to presense apps");
                Get.offAllNamed(Routes.HOME);
              }
            } else {
              Get.defaultDialog(
                title: "Belum Verifikasi",
                middleText: "kamu belum verifikasi akun ini, Lakukan verifikasi terlebih dahulu",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(), child: const Text("CANCEL")),
                  ElevatedButton(
                    onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil", "Kami telah berhasil mengirim email verifikasi ke akun anda");
                    } catch (e) {
                      Get.snackbar("Terjadi Kesalahan", "Kami tidak dapat mengirim email verifikasi. Hubungi admin!");
                    }
                  }, child: const Text("KIRIM ULANG")),
                ]
              );
            }
          }

          } on FirebaseAuthException catch (e) {
            // ada bug notif flutter authentication firebase, sementara catch tidak bisa digunakan
              Get.snackbar("Terjadi Kesalahan", "Email / Passsword Salah!.");
          } catch (e) {
            Get.snackbar("Terjadi Kesalahan", "tidak dapat login.");
          } finally {
            isLoading.value = false;
          }
        } else {
          Get.snackbar("Terjadi Kesalahan", "email dan password wajib diisi");
        }
      }
}
