// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/colors.dart';
import '../controllers/koleksi_controller.dart';

class KoleksiView extends GetView<KoleksiController> {
  KoleksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KoleksiController>(
        init: KoleksiController(),
        builder: (_) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: cornFlower,
              onPressed: () {
                Get.defaultDialog(
                  title: "Input Nama Koleksi",
                  content: Container(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Kendaraan',
                        counterText: "",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onFieldSubmitted: (value) {
                        debugPrint("Hasil Ketik : $value");
                        controller.simpanKoleksi(value);
                        Get.back();
                      },
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body: Container(
              child: StreamBuilder(
                stream: controller.service.listenToKoleksis(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return AlertDialog(
                      content: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    final items = snapshot.data;
                    if (items!.isNotEmpty) {
                      return GridView.count(
                        crossAxisCount: 2,
                        scrollDirection: Axis.vertical,
                        children: snapshot.hasData
                            ? snapshot.data!.map((koleksi) {
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.KOLEKSI_GAMBAR,
                                        arguments: koleksi);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${koleksi.gambars.length}",
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(koleksi.title),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()
                            : [],
                      );
                    } else {
                      return const Center(child: Text('Tidak ada koleksi'));
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          );
        });
  }
}
