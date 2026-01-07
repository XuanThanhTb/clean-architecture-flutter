import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_local_datasource_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource_impl.dart';
import '../../data/datasources/auth_remote_datasource_mock.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../presentation/bloc/login/login_cubit.dart';
import '../../presentation/bloc/theme/theme_cubit.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

// Set to true to use mock data source for demo purposes
const bool useMockDataSource = true;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final dio = ApiClient.createDio();
  sl.registerLazySingleton(() => dio);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    useMockDataSource
        ? () => AuthRemoteDataSourceMock()
        : () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Cubit
  sl.registerLazySingleton(() => ThemeCubit(
        sharedPreferences: sl(),
      ));
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        authRepository: sl(),
      ));
}
