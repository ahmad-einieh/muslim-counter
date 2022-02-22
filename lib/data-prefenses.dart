import 'package:shared_preferences/shared_preferences.dart';

class DataBox {
  // ignore: unused_field
  static SharedPreferences? _preferences;
  static const _colorKey = "color";
  static const _numberKey = "counter";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setColor(int number) async =>
      await _preferences!.setInt(_colorKey, number);

  static int? getColor() => _preferences!.getInt(_colorKey);

  static Future setCounter(int number) async =>
      await _preferences!.setInt(_numberKey, number);

  static int? getCounter() => _preferences!.getInt(_numberKey);
}
