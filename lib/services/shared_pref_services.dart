import 'package:shared_preferences/shared_preferences.dart';

///shared pref class if we want to save any thing to local storage we will use this class
class SharedPrefService {
  static SharedPreferences _pref;
  static bool instance = false;

  ///initializing sharedpref instance so that we can ues it below . without it we will need to calling await and making fucntion async which may not be possible any where
  Future<void> init() async {
    if (!instance) {
      _pref = await SharedPreferences.getInstance();
      instance = true;
    }
  }

  ///getting any data using key from local storage.
  dynamic getData(String key) {
    if (instance) {
      if (_pref.get(key) != null) {
        return _pref.get(key);
      }
    }
    return null;
  }

  ///setting/saving any data bool, string ,int , double in local storage or shared pref using this sample function.
  void setData(String key, dynamic value) {
    if (instance) {
      if (value is bool) {
        _pref.setBool(key, value);
      }
      if (value is String) {
        _pref.setString(key, value);
      }
      if (value is int) {
        _pref.setInt(key, value);
      }
      if (value is double) {
        _pref.setDouble(key, value);
      }
    } else {
      print('shared pref');
    }
  }
}
