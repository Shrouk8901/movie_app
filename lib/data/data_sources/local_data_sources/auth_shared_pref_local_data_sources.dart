import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSharedPrefLocalDataSources {
  Future<void> saveToken(String token) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(Constants.tokenKey, token);
      await sharedPreferences.setBool(Constants.loggedKey, true);
    } catch (exception) {
      throw const SharedPrefException('Failed to save token');
    }
  }

  Future<String> getToken() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getString(Constants.tokenKey)!;
    } catch (exception) {
      throw const SharedPrefException('Failed to get token');
    }
  }

  Future<bool> alreadyLogged() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool(Constants.loggedKey) ?? false;
    } catch (exception) {
      throw const SharedPrefException('Failed to get logged user ?');
    }
  }

  Future<void> deleteUserLoggedState() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setBool(Constants.loggedKey, false);
      await sharedPreferences.setBool(Constants.loggedKey, false);
    } catch (exception) {
      throw const SharedPrefException('Failed to delete logged user state?');
    }
  }
}
