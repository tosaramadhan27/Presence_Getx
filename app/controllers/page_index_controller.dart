import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    // pageIndex.value = i;
    // print('click index=$i');
    switch (i) {
      case 1:
        // print("Absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          var position = dataResponse['position'];
          // get location geocoding
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          // cek detail pilihan lokasi
          // print(placemarks);
          String address =
              "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality} , ${placemarks[0].subAdministrativeArea} , ${placemarks[0].country}";
          await updatePosition(position, address);

          // cek jarak / distance between 2 position(latlang)
          double distance = Geolocator.distanceBetween(
              -6.216925, 106.81634, position.latitude, position.longitude);

          // presensi
          await presensi(position, address, distance);
          // Get.snackbar("Berhasil", "anda telah mengisi absensi");
        } else {
          Get.snackbar("Terjadi Kesalahan", dataResponse['message']);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  // presensi
  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    // print(todayDocId);

    String status = "Di Luar Area";

    // cek position sebelum memasukkan data
    if (distance <= 200) {
      // didalam area
      status = "Didalam Area";
    }
    if (snapPresence.docs.length == 0) {
      // belum pernah absen & set absen masuk pertama kali
      await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText: "Absen MASUK Sekarang?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocId).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "Berhasil Absen MASUK");
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Ya",
                  style: TextStyle(color: Colors.white),
                )),
          ]);
    } else {
      // sudah pernah absen -> cek sudah absen masuk/keluar belum hari ini
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      if (todayDoc.exists == true) {
        // absen keluar atau sudah absen masuk & keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk & keluar
          Get.snackbar("Alert!",
              "Anda telah Melakukan Absen MASUK & KELUAR hari ini. ^_^");
        } else {
          // absen keluar (update)
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText: "Absen KELUAR Sekarang?",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style:
                      OutlinedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await colPresence.doc(todayDocId).update({
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        }
                      });
                      Get.back();
                      Get.snackbar("Berhasil", "Berhasil Absen KELUAR");
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Ya",
                      style: TextStyle(color: Colors.white),
                    )),
              ]);
        }
      } else {
        // absen masuk (set)
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText: "Absen Masuk Sekarang?",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocId).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "Berhasil Absen Masuk");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Ya",
                    style: TextStyle(color: Colors.white),
                  )),
            ]);
      }
    }
  }

  // update position
  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  // geolocator
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengakses GPS dari device",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin menggunakan GPS ditolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Aktifkan GPS!",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
