// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({super.key});
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Detail Presensi",
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
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   const SizedBox(height: 20,),
                   const Text(
                    "Masuk", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"
                  ),
                   Text(
                    "Posisi : ${data['masuk']!['lat']} , ${data['masuk']!['long']}",
                  ),
                   Text(
                    "Status : ${data['masuk']!['status']}",
                  ),
                   Text(
                    "Distance : ${data['masuk']!['distance'].toString().split(".").first} meter",
                  ),
                   Text(
                    "Address : ${data['masuk']!['address']}",
                  ),
                   const SizedBox(height: 20,),

                   const Text(
                    "Keluar", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['keluar']?['date'] == null 
                    ? "Jam : -" 
                    : "Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"
                  ),
                   Text(
                    data['keluar']?['lat'] == null 
                    && data['keluar']?['long'] == null 
                    ? "Posisi : -" 
                    : "Posisi : ${data['keluar']!['lat']} , ${data['keluar']!['long']}",
                  ),
                   Text(
                    data['keluar']?['status'] == null 
                    ? "Status : -" 
                    : "Status : ${data['keluar']!['status']}"
                  ),
                  Text(
                    data['keluar']?['distance'] == null 
                    ? "Distance : -" 
                    : "Distance : ${data['masuk']!['distance'].toString().split(".").first} meter",
                  ),
                   Text(
                    data['keluar']?['address'] == null 
                    ? "Address : -" 
                    : "Address : ${data['masuk']!['address']}",
                  ),
                   const SizedBox(height: 20,),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
            ),
        ]
      ),
    );
  }
}
