import 'package:shared_preferences/shared_preferences.dart';

class loginData {

  // to save token
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // to get token value
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.get("token"));
    return prefs.getString('token');

  }

  // to remove the token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
