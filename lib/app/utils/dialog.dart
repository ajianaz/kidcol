import 'package:flutter/material.dart';
import 'package:get/get.dart';

dialogKonfirmasi(
    {String? title,
    String? subtitle,
    String? textConfirm,
    Function()? onConfirm,
    Function()? onCancel}) {
  Get.defaultDialog(
      title: title.toString(),
      content: Text("$subtitle"),
      textConfirm: textConfirm ?? "OK",
      textCancel: "Tutup",
      onConfirm: onConfirm ?? () {},
      onCancel: onCancel ?? () {});
}

dialogPopUp(
    {String? title,
    String? subtitle,
    Function()? onConfirm,
    Function()? onCancel}) {
  Get.defaultDialog(
      title: title.toString(),
      content: Text("$subtitle"),
      textConfirm: "OK",
      textCancel: "Tutup",
      onConfirm: onConfirm ?? () {},
      onCancel: onCancel ?? () {});
}
