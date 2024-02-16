// ignore_for_file: implementation_imports

import 'dart:ui';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/src/painting/text_style.dart';

class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 4;

  @override
  double get iconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 16, color: color);
  }

  // @override
  // TextStyle textStyle(Color color) {
  //   return TextStyle(fontSize: 20, color: color);
  // }
}
