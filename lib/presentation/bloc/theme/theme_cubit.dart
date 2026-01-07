import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeModeKey = 'THEME_MODE';

  ThemeCubit({required this.sharedPreferences}) : super(const ThemeState()) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final savedMode = sharedPreferences.getString(_themeModeKey);
    if (savedMode != null) {
      final themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeMode.system,
      );
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await sharedPreferences.setString(_themeModeKey, themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    await setThemeMode(newMode);
  }

  ThemeMode get themeMode {
    switch (state.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
