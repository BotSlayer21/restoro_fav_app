import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const darkTheme = 'DARK_THEME';
  static const dailyReminder = 'DAILY_REMINDER';

  Future<bool> get isDarkTheme async {
    try {
      final prefs = await sharedPreferences;
      return prefs.getBool(darkTheme) ?? false;
    } catch (e) {
      throw Exception('Error occurred while fetching dark theme status: $e');
    }
  }

  Future<void> setDarkTheme(bool value) async {
    try {
      final prefs = await sharedPreferences;
      await prefs.setBool(darkTheme, value);
    } catch (e) {
      throw Exception('Failed to set dark theme: $e');
    }
  }

  Future<bool> get isDailyReminderActive async {
    try {
      final prefs = await sharedPreferences;
      return prefs.getBool(dailyReminder) ?? false;
    } catch (e) {
      throw Exception(
          'Error occurred while fetching daily reminder status: $e');
    }
  }

  Future<void> setDailyReminder(bool value) async {
    try {
      final prefs = await sharedPreferences;
      await prefs.setBool(dailyReminder, value);
    } catch (e) {
      throw Exception('Failed to set daily reminder: $e');
    }
  }
}
