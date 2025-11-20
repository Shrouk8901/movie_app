import 'package:movies_app/core/constants/constants.dart';
import 'package:movies_app/core/constants/errors/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserExistanceSharedPrefLocaleSource {

  Future<bool> checkAlreadySeenOnboarding() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      bool isSeen = sharedPref.getBool(Constants.sennOnboardingKey)??false;
      return isSeen;
    } catch (ex) {
      throw SharedPrefException('Failed to get already seen onboarding?');
    }
  }

  Future<void> finishOnboarding() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setBool(Constants.sennOnboardingKey,true);
    } catch (ex) {
      throw SharedPrefException('Failed to set already seen onboarding?');
    }
  }
  
}
