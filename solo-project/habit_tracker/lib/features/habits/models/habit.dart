import 'package:flutter/material.dart';
import 'package:habit_tracker/core/utils/color_utils.dart';

enum HabitType { simple, counter }

/// Represents a single habit.
class Habit {
  final int id;
  final String userId;
  final String name;
  final String? description;
  final Color color;
  final DateTime createdAt;

  // Fields for counter habits
  final HabitType habitType;
  final int? counterGoal;
  final int? counterStep;
  final String? unitLabel;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.color,
    required this.createdAt,
    this.habitType = HabitType.simple,
    this.counterGoal,
    this.counterStep,
    this.unitLabel,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      color: ColorUtils.fromHex(json['color_hex']),
      createdAt: DateTime.parse(json['created_at']),
      habitType: (json['habit_type'] == 'counter') ? HabitType.counter : HabitType.simple,
      counterGoal: json['counter_goal'],
      counterStep: json['counter_step'],
      unitLabel: json['unit_label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'description': description,
      'color_hex': ColorUtils.toHex(color),
      'habit_type': habitType.name,
      'counter_goal': counterGoal,
      'counter_step': counterStep,
      'unit_label': unitLabel,
    };
  }
}
