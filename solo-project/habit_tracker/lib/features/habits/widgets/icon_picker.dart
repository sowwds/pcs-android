import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/utils/icon_utils.dart';

/// Shows a dialog with a grid of selectable icons.
///
/// Returns the name of the selected icon as a `String`.
Future<String?> showIconPicker({
  required BuildContext context,
  required Color iconColor,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      final availableIcons = IconUtils.availableIconNames;

      return AlertDialog(
        title: const Text('Выберите иконку'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: availableIcons.length,
            itemBuilder: (context, index) {
              final iconName = availableIcons[index];
              final iconData = IconUtils.getIconData(iconName);
              return IconButton(
                icon: Icon(iconData, color: iconColor, size: 30),
                onPressed: () {
                  // Return the selected icon name
                  Navigator.of(context).pop(iconName);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close without selection
            },
            child: const Text('Отмена'),
          ),
        ],
      );
    },
  );
}
