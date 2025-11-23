// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/app_string.dart';
import 'package:kidcol/app/widgets/cards/card_image.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/koleksi_gambar_controller.dart';

class KoleksiGambarView extends GetView<KoleksiGambarController> {
  const KoleksiGambarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KoleksiGambarController>(
        init: KoleksiGambarController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '${t.collection.title_prefix} ${controller.koleksi.title}'),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => Get.toNamed(Routes.PRINTING_PDF,
                            arguments: controller.koleksi),
                        child: Icon(Icons.print),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () => controller.konfirmasiHapusKoleksi(),
                        child: Icon(Icons.delete),
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: StreamBuilder(
              stream: controller.service.listenToGambars(controller.koleksi),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return AlertDialog(
                    content: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  final items = snapshot.data;
                  if (items!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var gambar = items.elementAt(index);
                        return InkWell(
                          onTap: () {
                            // TODO Konfirmasi Hapus
                            // controller.getAllKoleksi();
                            // dialogKoleksis(gambar.name.toString());
                            Get.defaultDialog(
                              title: t.dialog.confirm_delete_image,
                              content: Container(
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: "${gambar.endpoint}"),
                                    Text(
                                      t.dialog.confirm_delete_image_message,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              textConfirm: t.common.delete,
                              textCancel: t.common.cancel,
                              onConfirm: () {
                                controller.deleteGambarKoleksi(gambar);
                                Get.back();
                              },
                              onCancel: () => Get.back(),
                            );
                          },
                          child: CardImage(
                            imageUrl: "${gambar.endpoint}",
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text(t.dialog.no_images));
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          );
        });
  }
}
