import 'package:hive/hive.dart';

class HiveStorage {
  static const String _boxName = 'authBox';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  // ================= TOKEN =================
  static Future<void> saveToken(
    String token,
  ) async {
    await _box.put('token', token);
  }

  static String? getToken() {
    return _box.get('token');
  }

  // ================= USER ID =================
  static Future<void> saveUserId(
    String id,
  ) async {
    await _box.put('user_id', id);
  }

  static String? getUserId() {
    return _box.get('user_id');
  }

  // ================= ROLE =================
  static Future<void> saveRole(
    String role,
  ) async {
    await _box.put('role', role);
  }

  static String? getRole() {
    return _box.get('role');
  }

  // ================= LOGIN CHECK =================
  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // ================= NAV INDEX =================
  static int getNavIndex() {
    return _box.get('nav_index', defaultValue: 1);
  }

  static Future<void> setNavIndex(
    int index,
  ) async {
    await _box.put('nav_index', index);
  }

  // ================= LOGOUT =================
  static Future<void> clear() async {
    await _box.clear();
  }
}
