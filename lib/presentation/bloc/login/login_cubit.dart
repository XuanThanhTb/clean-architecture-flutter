import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final AuthRepository authRepository;

  LoginCubit({
    required this.loginUseCase,
    required this.authRepository,
  }) : super(const LoginState()) {
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final result = await authRepository.getSavedCredentials();
    result.fold(
      (failure) => null,
      (credentials) {
        if (credentials != null) {
          emit(state.copyWith(
            email: credentials['email'] ?? '',
            password: credentials['password'] ?? '',
            rememberMe: true,
            isValid: _validateInputs(
              credentials['email'] ?? '',
              credentials['password'] ?? '',
            ),
          ));
        }
      },
    );
  }

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      isValid: _validateInputs(email, state.password),
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      isValid: _validateInputs(state.email, password),
    ));
  }

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> login(String email, String password) async {
    if (!_validateInputs(email, password)) {
      emit(state.copyWith(
        errorMessage: 'Please enter valid email and password',
      ));
      return;
    }

    emit(state.copyWith(
      isSubmitting: true,
      errorMessage: null,
    ));

    final result = await loginUseCase(
      LoginParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: failure.message,
      )),
      (user) async {
        if (state.rememberMe) {
          await authRepository.saveCredentials(email, password);
        } else {
          await authRepository.clearCredentials();
        }

        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: null,
        ));
      },
    );
  }

  bool _validateInputs(String email, String password) {
    return email.isNotEmpty &&
        email.contains('@') &&
        password.isNotEmpty &&
        password.length >= 6;
  }
}
