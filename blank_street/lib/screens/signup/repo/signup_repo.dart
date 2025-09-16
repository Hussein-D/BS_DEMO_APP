import 'dart:convert';

import 'package:blank_street/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SignupRepo {
  Future<void> signup({required User user});
  Future<User?> autologin();
  Future<void> logout();
}

class SignupRepoImpl implements SignupRepo {
  @override
  Future<void> signup({required User user}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toJson()));
  }

  @override
  Future<User?> autologin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userAsString = prefs.getString("user");
    if (userAsString != null) {
      return User.fromJson(jsonDecode(userAsString));
    } else {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}
