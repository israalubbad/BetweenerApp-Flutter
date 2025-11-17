import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  late SharedPreferences _prefs;
  SharedPrefsHelper._();

  static SharedPrefsHelper? _instance;


  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  factory SharedPrefsHelper(){
    return _instance ??= SharedPrefsHelper._();
  }

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }


  void setData(String key, dynamic value) async {
    if (_prefs == null) await init();
    if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    }
  }

  T? getValueFor<T>(String key){
    if(_prefs.containsKey(key)){
      return _prefs.get(key) as T ;
    }
    return null;
  }

  Future<bool?> remove(String key) async {
    return _prefs?.remove(key);
  }

  Future<bool?> clear() async {
    return _prefs?.clear();
  }
}
