
import 'package:shared_preferences/shared_preferences.dart';

class AccessStatus {

  static Future<bool> setAccess() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(!sharedPreferences.containsKey('isFirstAccess')){
      sharedPreferences.setBool('isFirstAccess', true);
    } else{
      sharedPreferences.setBool('isFirstAccess', false);
    }

    bool isFirstAccess = sharedPreferences.getBool('isFirstAccess')!;

    return isFirstAccess;
  }

  static Future<void> reset() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('isFirstAccess')){
      sharedPreferences.setBool('isFirstAccess', true);
    }
  }

}