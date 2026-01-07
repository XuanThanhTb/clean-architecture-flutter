import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/theme/theme_cubit.dart';
import '../../presentation/bloc/theme/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<AppThemeMode>(
          icon: Icon(
            state.themeMode == AppThemeMode.dark
                ? Icons.dark_mode
                : state.themeMode == AppThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
          ),
          tooltip: 'Theme',
          onSelected: (mode) {
            context.read<ThemeCubit>().setThemeMode(mode);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: AppThemeMode.light,
              child: Row(
                children: [
                  const Icon(Icons.light_mode, size: 20),
                  const SizedBox(width: 12),
                  const Text('Light'),
                  if (state.themeMode == AppThemeMode.light) const Spacer(),
                  if (state.themeMode == AppThemeMode.light)
                    const Icon(Icons.check, size: 20),
                ],
              ),
            ),
            PopupMenuItem(
              value: AppThemeMode.dark,
              child: Row(
                children: [
                  const Icon(Icons.dark_mode, size: 20),
                  const SizedBox(width: 12),
                  const Text('Dark'),
                  if (state.themeMode == AppThemeMode.dark) const Spacer(),
                  if (state.themeMode == AppThemeMode.dark)
                    const Icon(Icons.check, size: 20),
                ],
              ),
            ),
            PopupMenuItem(
              value: AppThemeMode.system,
              child: Row(
                children: [
                  const Icon(Icons.brightness_auto, size: 20),
                  const SizedBox(width: 12),
                  const Text('System'),
                  if (state.themeMode == AppThemeMode.system) const Spacer(),
                  if (state.themeMode == AppThemeMode.system)
                    const Icon(Icons.check, size: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
