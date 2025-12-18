import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/screens/habit_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // Initialize Supabase for testing purposes before any tests run.
  setUpAll(() async {
    // Mock shared_preferences for Supabase initialization in a test environment.
    SharedPreferences.setMockInitialValues({});
    
    await Supabase.initialize(
      url: 'https://bdgefkojubnsagyfdzgs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkZ2Vma29qdWJuc2FneWZkemdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4OTIwMTgsImV4cCI6MjA4MDQ2ODAxOH0.gbqNCJPUcyFPcr-nRczyTmhprUATW-9hjkLhMOW3Ey8',
    );
  });

  // Helper function to pump the widget with necessary ancestors
  Future<void> pumpHabitFormScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HabitFormScreen(),
    ));
  }

  testWidgets('HabitFormScreen renders correctly in create mode', (WidgetTester tester) async {
    await pumpHabitFormScreen(tester);

    // Verify the title is 'New Habit'
    expect(find.text('New Habit'), findsOneWidget);

    // Verify that main fields are present
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Icon'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
  });

  testWidgets('Show validation error when name is empty', (WidgetTester tester) async {
    await pumpHabitFormScreen(tester);

    final saveButtonFinder = find.text('Save Habit');

    // Scroll until the button is visible before tapping
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();

    // Find the save button and tap it without entering a name
    await tester.tap(saveButtonFinder);
    await tester.pump(); // Rebuild the widget after the tap

    // Verify that the validation error message is shown
    expect(find.text('Please enter a name'), findsOneWidget);
  });

  testWidgets('Toggling counter switch shows counter-specific fields', (WidgetTester tester) async {
    await pumpHabitFormScreen(tester);

    // Initially, counter fields should not be visible
    expect(find.text('Daily Goal'), findsNothing);
    expect(find.text('Step'), findsNothing);
    expect(find.text('Unit (e.g., ml, pages)'), findsNothing);

    // Find the switch and tap it
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump(); // Rebuild the widget

    // Now, the counter-specific fields should be visible
    expect(find.text('Daily Goal'), findsOneWidget);
    expect(find.text('Step'), findsOneWidget);
    expect(find.text('Unit (e.g., ml, pages)'), findsOneWidget);
  });
}
