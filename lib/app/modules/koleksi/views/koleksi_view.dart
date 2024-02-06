// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/services/isar_service.dart';

import '../controllers/koleksi_controller.dart';

class KoleksiView extends GetView<KoleksiController> {
  KoleksiView({Key? key}) : super(key: key);

  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            debugPrint("FAB PRESSED");
          }),
      body: Container(
        child: StreamBuilder(
          stream: service.listenToKoleksis(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                content: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              final items = snapshot.data;
              if (items != null) {
                return GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: snapshot.hasData
                      ? snapshot.data!.map((koleksi) {
                          return Container(
                            color: Colors.grey,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text("${koleksi.gambars.length}"),
                                Text(koleksi.title),
                              ],
                            ),
                          );
                        }).toList()
                      : [],
                );
              } else {
                return const Center(child: Text('No data found!'));
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
