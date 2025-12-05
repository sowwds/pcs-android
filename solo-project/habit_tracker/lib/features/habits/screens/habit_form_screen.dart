import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'package:habit_tracker/core/services/supabase_service.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
import 'package:habit_tracker/features/habits/services/habits_service.dart';
import 'package:habit_tracker/features/habits/widgets/color_picker.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;

  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalController = TextEditingController();
  final _stepController = TextEditingController();
  final _unitLabelController = TextEditingController();
  
  final _habitsService = HabitsService();

  late Color _selectedColor;
  bool _isCounterHabit = false;
  bool _isLoading = false;

  final List<Color> _availableColors = [
    AppColors.lavender, AppColors.mauve, AppColors.sapphire, AppColors.blue,
    AppColors.green, AppColors.yellow, AppColors.peach, AppColors.red,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _descriptionController.text = widget.habit!.description ?? '';
      _selectedColor = widget.habit!.color;
      _isCounterHabit = widget.habit!.habitType == HabitType.counter;
      if(_isCounterHabit) {
        _goalController.text = widget.habit!.counterGoal?.toString() ?? '';
        _stepController.text = widget.habit!.counterStep?.toString() ?? '';
        _unitLabelController.text = widget.habit!.unitLabel ?? '';
      }
    } else {
      _selectedColor = _availableColors.first;
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = SupabaseService.instance.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final habit = Habit(
        id: widget.habit?.id ?? 0,
        userId: user.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        color: _selectedColor,
        createdAt: widget.habit?.createdAt ?? DateTime.now(),
        habitType: _isCounterHabit ? HabitType.counter : HabitType.simple,
        counterGoal: _isCounterHabit ? int.tryParse(_goalController.text) : null,
        counterStep: _isCounterHabit ? int.tryParse(_stepController.text) : null,
        unitLabel: _isCounterHabit ? _unitLabelController.text.trim() : null,
      );

      if (widget.habit == null) {
        await _habitsService.createHabit(habit);
      } else {
        await _habitsService.updateHabit(habit);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save habit: ${e.toString()}'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'New Habit' : 'Edit Habit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text('Color', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ColorPicker(
                selectedColor: _selectedColor,
                availableColors: _availableColors,
                onColorSelected: (color) => setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('Counter Habit', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('e.g., tracking glasses of water'),
                value: _isCounterHabit,
                onChanged: (value) => setState(() => _isCounterHabit = value),
                activeColor: AppColors.lavender,
              ),
              if (_isCounterHabit) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _goalController,
                  decoration: const InputDecoration(labelText: 'Daily Goal'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   validator: (value) {
                    if (_isCounterHabit && (value == null || value.trim().isEmpty)) {
                      return 'Please enter a goal';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _stepController,
                  decoration: const InputDecoration(labelText: 'Step'),
                   keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                   validator: (value) {
                    if (_isCounterHabit && (value == null || value.trim().isEmpty)) {
                      return 'Please enter a step';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _unitLabelController,
                  decoration: const InputDecoration(labelText: 'Unit (e.g., ml, pages)'),
                   validator: (value) {
                    if (_isCounterHabit && (value == null || value.trim().isEmpty)) {
                      return 'Please enter a unit label';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveHabit,
                      child: const Text('Save Habit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
