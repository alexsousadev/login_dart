// lib/env_variables.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvVariables {
  static Future<void> load() async {
    await dotenv.load(fileName: "../.env");
  }

  String get mapsKey => dotenv.env['MAPS_KEY']!;

  String get supabaseUrl => dotenv.env['SUPABASE_URL']!;

  String get apiKey => dotenv.env['SUPABASE_KEY']!;
}
