import 'package:flutter/material.dart';

/// A utility class for handling habit icons.
class IconUtils {
  /// A map of icon names to their respective IconData.
  static final Map<String, IconData> _iconMap = {
    'sports': Icons.sports_kabaddi,
    'book': Icons.book,
    'water_drop': Icons.water_drop,
    'bed': Icons.bed,
    'work': Icons.work,
    'star': Icons.star,
    'heart': Icons.favorite,
    'fitness': Icons.fitness_center,
    'code': Icons.code,
    'music': Icons.music_note,
    'coffee': Icons.coffee,
    'run': Icons.directions_run,
    'leaf': Icons.eco,
    'meditation': Icons.self_improvement,
    'money': Icons.attach_money,
    'default': Icons.task_alt,
  };

  /// Returns a list of all available icon names for selection.
  static List<String> get availableIconNames => _iconMap.keys.where((name) => name != 'default').toList();

  /// Gets the IconData for a given icon name.
  ///
  /// Returns a default icon if the name is null or not found.
  static IconData getIconData(String? iconName) {
    return _iconMap[iconName] ?? _iconMap['default']!;
  }
}
