import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationSharedPrefLocalDataSource {
  Future<String> getLocale() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      String language = sharedPref.getString(Constants.languageKey) ?? 'en';
      return language;
    } catch (ex) {
      throw SharedPrefException('Failed to get locale');
    }
  }

  Future<void> setLocale(String lang) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString(Constants.languageKey, lang);
    } catch (ex) {
      throw SharedPrefException('Failed to set locale');
    }
  }
}
