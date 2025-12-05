import 'package:flutter/material.dart';

/// A utility class for color-related operations.
class ColorUtils {
  const ColorUtils._();

  /// Converts a [Color] object to a hex string (e.g., '#RRGGBB').
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).padLeft(6, '0')}';
  }

  /// Converts a hex string (e.g., '#RRGGBB') to a [Color] object.
  ///
  /// Falls back to a default color (black) if the format is invalid.
  static Color fromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.black;
    }
  }
}
