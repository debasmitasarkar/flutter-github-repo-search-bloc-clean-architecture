import 'package:flutter/material.dart';

class ColorConstants {
  static const Color white100 = Color(0xFFFFFFFF);
  static const Color black100 = Color(0xFF000000);

  static const Color blue800 = Color(0xFF1565C0);
  static const Color blue600 = Color(0xFF1E88E5);

  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey100 = Color(0xFFE0E0E0);

  static const Color yellow600 = Color(0xFFFDD835);

  static const Color red600 = Color(0xFFE53935);
}

class TextStyleConstants {
  static const largeBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorConstants.white100,
  );

  static const TextStyle bodyNormal = TextStyle(
    color: ColorConstants.grey400,
  );

  static const TextStyle smNormal = TextStyle(
    color: ColorConstants.grey700,
    fontSize: 12.0,
  );
}
