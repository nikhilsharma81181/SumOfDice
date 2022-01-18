import 'package:shared_preferences/shared_preferences.dart';

class SavedSettings {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setSound(bool sound) async {
    await _preferences!.setBool('sound', sound);
  }

  static bool? getSound() => _preferences!.getBool('sound');

  static Future setVibartions(bool vib) async {
    await _preferences!.setBool('vib', vib);
  }

  static bool? getVib() => _preferences!.getBool('vib');

  static Future setLanguage(int lang) async {
    await _preferences!.setInt('lang', lang);
  }

  static int? getLang() => _preferences!.getInt('lang');

  static Future setScore(int score) async {
    await _preferences!.setInt('score', score);
  }

  static int? getScore() => _preferences!.getInt('score');
}
