import 'package:supabase_flutter/supabase_flutter.dart';

/// A singleton service to manage the Supabase client instance.
///
/// This allows easy access to the Supabase client from anywhere in the app.
/// Example: `SupabaseService.instance`
class SupabaseService {
  SupabaseService._();

  static final SupabaseClient instance = Supabase.instance.client;
}
