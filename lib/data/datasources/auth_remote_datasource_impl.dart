import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerFailure(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkFailure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('No internet connection');
      } else if (e.response != null) {
        throw ServerFailure(
          e.response?.data['message'] ?? 'Server error occurred',
        );
      } else {
        throw const ServerFailure('An unexpected error occurred');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
