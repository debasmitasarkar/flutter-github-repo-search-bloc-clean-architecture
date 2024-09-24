import 'package:flutter/material.dart';

extension IntExetension on int {
  String toFileSizeFromKB() {
    if (this < 1024) {
      return '$this KB';
    } else {
      return '${(this / 1024).toStringAsFixed(2)} MB';
    }
  }
}

extension ScrollControllerExtension on ScrollController {
  bool get shouldFetch {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    return currentScroll >= (maxScroll * 0.8);
  }
}
