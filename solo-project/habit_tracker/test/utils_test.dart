import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/utils/color_utils.dart';
import 'package:habit_tracker/features/habits/utils/icon_utils.dart';

void main() {
  group('ColorUtils', () {
    test('toHex should convert Color to correct hex string', () {
      const color = Color(0xFFFF5733);
      expect(ColorUtils.toHex(color), '#ff5733');
    });

    test('fromHex should convert valid hex string to Color', () {
      const hex = '#FF5733';
      expect(ColorUtils.fromHex(hex), const Color(0xFFFF5733));
    });

    test('fromHex should fall back to black for invalid hex string', () {
      const hex = 'invalid';
      expect(ColorUtils.fromHex(hex), Colors.black);
    });
  });

  group('IconUtils', () {
    test('getIconData should return correct icon for a valid name', () {
      expect(IconUtils.getIconData('book'), Icons.book);
    });

    test('getIconData should return default icon for an invalid name', () {
      expect(IconUtils.getIconData('non_existent_icon'), Icons.task_alt);
    });

    test('getIconData should return default icon for null name', () {
      expect(IconUtils.getIconData(null), Icons.task_alt);
    });

    test('availableIconNames should not contain the default icon', () {
      expect(IconUtils.availableIconNames.contains('default'), isFalse);
    });
  });
}
