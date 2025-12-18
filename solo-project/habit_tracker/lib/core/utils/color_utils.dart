import 'package:flutter/material.dart';

/// A utility class for color-related operations.
class ColorUtils {
  const ColorUtils._();

  /// Converts a [Color] object to a hex string (e.g., '#RRGGBB').
  static String toHex(Color color) {
    // Use toARGB32() to get the color value as an integer, then mask for RGB.
    return '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
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
