import 'dart:async';
import '../../core/error/failures.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'demo@example.com' && password == 'password123') {
      return const UserModel(
        id: '1',
        email: 'demo@example.com',
        name: 'Demo User',
        token: 'mock_token_12345',
      );
    } else {
      throw const ServerFailure('Invalid email or password');
    }
  }
}
