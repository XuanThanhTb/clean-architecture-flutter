import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failures.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _userKey = 'CACHED_USER';
  static const String _savedEmailKey = 'SAVED_EMAIL';
  static const String _savedPasswordKey = 'SAVED_PASSWORD';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await sharedPreferences.setString(_userKey, userJson);
    } catch (e) {
      throw CacheFailure('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_userKey);
    } catch (e) {
      throw CacheFailure('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    try {
      await sharedPreferences.setString(_savedEmailKey, email);
      await sharedPreferences.setString(_savedPasswordKey, password);
    } catch (e) {
      throw CacheFailure('Failed to save credentials: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      final email = sharedPreferences.getString(_savedEmailKey);
      final password = sharedPreferences.getString(_savedPasswordKey);

      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get saved credentials: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCredentials() async {
    try {
      await sharedPreferences.remove(_savedEmailKey);
      await sharedPreferences.remove(_savedPasswordKey);
    } catch (e) {
      throw CacheFailure('Failed to clear credentials: ${e.toString()}');
    }
  }
}
