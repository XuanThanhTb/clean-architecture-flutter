import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, void>> saveCredentials(String email, String password);
  Future<Either<Failure, Map<String, String>?>> getSavedCredentials();
  Future<Either<Failure, void>> clearCredentials();
}
